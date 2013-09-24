module ResqueSafe
  module ConvertFromHash
    def args_to_instance_vars(args)
      #take each key, if a model, make it an @#{model} = model.find(value)
      #else make it a @#{name}=#{value}

      args.each do |klass_name,value|
        klass_name, value = klass_name.to_s, value.to_s
        klassified_klass = klass_name.classify

        if Object.const_defined?(klassified_klass) &&
          known_models.include?(klassified_klass.constantize)

          set_for_active_record(klass_name, value)
        else
          set_for_other(klass_name, value)
        end
      end
    end

    private
    def set_for_active_record(klass_name, value)
      self.instance_eval("@#{klass_name}= #{klassified_klass}.find(#{value})")
    end

    def set_for_other(instance_name, value)
      if value.is_a?(String)
        self.instance_eval("@#{instance_name} = %|#{value}|")
      else
        self.instance_eval("@#{instance_name}=#{value}")
      end
    end
  end
end
