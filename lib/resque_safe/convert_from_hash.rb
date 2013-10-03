module ResqueSafe
  module ConvertFromHash
    def to_objects(inbound_hash)
      objects = {}
      inbound_hash.each do |klass_name,value|
        klass_name, value = klass_name.to_s, value.to_s
        klassified_klass = klass_name.classify
        symbolized_klass = klass_name.to_sym

        if Object.const_defined?(klassified_klass) &&
          known_models.include?(klassified_klass.constantize)

          objects[symbolized_klass] = return_active_record(klassified_klass, value)
        else
          objects[symbolized_klass] = return_other_object(klass_name, value)
        end
      end

      objects
    end

    def args_to_instance_vars(args)
      #take each key, if a model, make it an @#{model} = model.find(value)
      #else make it a @#{name}=#{value}

      args.each do |klass_name,value|
        klass_name, value = klass_name.to_s, value.to_s
        klassified_klass = klass_name.classify

        if Object.const_defined?(klassified_klass) &&
          known_models.include?(klassified_klass.constantize)

          set_instance_for_active_record(klassified_klass, value)
        else
          set_instance_for_other(klass_name, value)
        end
      end
    end

    private
    def return_active_record(klass_name, value)
      return self.instance_eval("#{klass_name.constantize}.find(#{value})")
    end

    def return_other_object(klass_name, value)
      if value.is_a?(String)
        return self.instance_eval("%|#{value}|")
      else
        return self.instance_eval(":#{instance_name} => #{value}")
      end

    end

    def set_instance_for_active_record(klass_name, value)
      self.instance_eval("@#{klass_name}= #{klass_name.constantize}.find(#{value})")
    end

    def set_instance_for_other(instance_name, value)
      if value.is_a?(String)
        self.instance_eval("@#{instance_name} = %|#{value}|")
      else
        self.instance_eval("@#{instance_name}=#{value}")
      end
    end
  end
end
