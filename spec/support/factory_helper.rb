def class_factory(opts = {}, &block)
  Class.new(described_class).tap do |klass|
    klass.class_eval(&block) if block_given?
    Object.const_set(opts[:name], klass) if opts[:name]
  end
end

def object_factory(opts = {}, &block)
  class_factory(opts, &block).new(opts.fetch(:dependencies, {}))
end

def binding_object_factory(&block)
  # Class.new(Object).tap do |klass|
  #   if block_given?
  #     klass.class_eval(&block)
  #   else
  #     klass.class_eval do
  #       def success_action(_subject); end

  #       def fail_action(_subject, _errors); end
  #     end
  #   end
  # end.new
end
