module ModelOperations
  module ActiveRecordOperation
    # def self.included(base)
    #   base.rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # end

    def read(id = nil)
      klass.find(id || model_id)
    rescue ActiveRecord::RecordNotFound => exception
      @errors = [message: exception.message]
      nil
    end

    def update
      read.tap do |m|
        m.update_attributes(params.except(id_attr))
        save!(m) if model_valid?(m)
      end
    end

    def destroy
      model_class.destroy(model_id)
    end

    def create
      klass.new(params).tap do |m| # valid_params)
        save!(m) if model_valid?(m)
      end
    end

    def save!(m)
      m.save!
    end

    def prepare_params(params)
      @params = properties ? params.permit(properties) : params.permit!
    end
  end
end
