module ModelOperations
  class Core
    include ::ActiveSupport::Rescuable

    MissingDependency = Class.new(StandardError)
    MissingModel      = Class.new(StandardError)

    def initialize(dependencies = {})
      @dependencies = dependencies
    end

    class << self
      def core_config
        @core_config ||= {}
      end

      def kind(type)
        fail("[ModelOperations] unknown #{type} kind type.") unless [:create, :update, :read, :destroy].include?(type)
        core_config[:kind] = type
      end

      def model(subject)
        core_config[:model] = subject
      end

      def validation(&block)
        core_config[:validation] = block
      end

      def properties(*attrs)
        core_config[:properties] = attrs
      end
    end

    def kind
      self.class.core_config[:kind] || :read
    end

    def model_class
      self.class.core_config[:model] || fail(MissingModel)
    end

    def on_success(binded_method = nil, &block)
      actions[:success] = binded_method || block
      self
    end

    def on_fail(binded_method = nil, &block)
      actions[:fail] = binded_method || block
      self
    end

    def on(actions_with_responses = {})
      actions_assign(actions_with_responses, :success, :fail)
      self
    end

    def bind_with(bind_object)
      @bind_object = bind_object
      self
    end

    def run(params = {})
      params_setup(params)
      execute
      execute_finalize
      self
    rescue => exception
      rescue_with_handler(exception) || raise
      self
    end

    def errors
      @errors ||= fail_object || (model_instance.respond_to?(:errors) ? model_instance.errors : [])
    end

    def fail?
      !success?
    end

    def fail!(object = true)
      @fail_object = object
    end

    def success?
      errors.respond_to?(:empty?) ? errors.empty? : !errors
    end

    def model(*args)
      model_instance || instantiate_model(*args) || fail('[ModelOperations] model not found.')
    end

    private

    def instantiate_model(*args)
      return model_class.new(*args) if kind == :create
      read((args[0] || {})[id_attr])
    end

    attr_reader :dependencies, :bind_object, :params, :prepared_params, :model_instance, :fail_object

    def validation
      self.class.core_config[:validation]
    end

    def properties
      self.class.core_config[:properties]
    end

    def execute
    end

    def execute_finalize
      @model_instance = execute_crud_method
      execute_actions
    end

    def id_attr
      :id
    end

    def model_id
      params.fetch(id_attr)
    end

    def execute_crud_method
      self.send(kind)
    end

    def execute_actions
      success? ? execute_action_type(:success) : execute_action_type(:fail)
    end

    def execute_action_type(type)
      return unless actions.key?(type)
      action = actions[type]
      bind_object.send(action, self) if action.is_a?(Symbol) && bind_object
      action.call(self) if action.is_a?(Proc)
    end

    def actions
      @actions ||= {}
    end

    def actions_assign(hash, *keys)
      keys.each { |key| actions[key] = hash[key] if hash.key?(key) }
    end

    def params_setup(params)
      @params = params.permit!
    end

    def klass
      return model_class unless validation
      Class.new(model_class).tap do |m_class|
        m_class.class_eval("def self.name; \"#{model_class}\"; end")
        m_class.class_eval(&validation)
      end
    end

    def model_valid?(m)
      m.valid?
    end

    def form_class
      Class.new(model_class).tap do |m_class|
        operation_name = kind
        m_class.class_eval("def self.name; \"#{model_class}::#{operation_name}Form\"; end")
        m_class.class_eval(&validation) if validation
      end
    end

    def dependency(name)
      dependencies.fetch(name)
    rescue KeyError => e
      raise MissingDependency, e.message
    end
  end
end
