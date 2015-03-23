module ModelOperations
  class Core
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
        fail("[ModelOperations] unknown #{type} kind type.") unless [:create, :update, :read, :delete].include?(type)
        core_config[:kind] = type
      end

      def model(subject)
        core_config[:model] = subject
      end
    end

    def kind
      self.class.core_config[:kind] || :read
    end

    def model
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

    private

    attr_reader :dependencies, :bind_object

    def actions
      @actions ||= {}
    end

    def actions_assign(hash, *keys)
      keys.each { |key| actions[key] = hash[key] if hash.key?(key) }
    end

    def dependency(name)
      dependencies.fetch(name)
    rescue KeyError => e
      raise MissingDependency, e.message
    end
  end
end
