
module ResqueSafe
  module ConvertFromHash
    def args_to_objects(inbound_hash)
      raise NotImplementedError.new "This isn't completed, not sure how to set it up"

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

    def set_instance_args_for_class(mailer_instance, args)
       #take each key, if a model, make it an @#{model} = model.find(value)
      #else make it a @#{name}=#{value}

      args.each do |klass_name,value|
        klass_name, value = klass_name.to_s, value.to_s
        klassified_klass = klass_name.classify

        if Object.const_defined?(klassified_klass) &&
          known_models.include?(klassified_klass.constantize)

          set_instance_for_active_record_mailer_instance(mailer_instance, klassified_klass, value)
        else
          set_instance_for_other_mialer_instance(mailer_instance, klass_name, value)
        end
      end
    end

    private
    def set_instance_for_active_record(klass_name, value)
      set_instance_for_active_record_mailer_instance(self, klass_name, value)
    end

    def set_instance_for_active_record_mailer_instance(mailer_instance, klass_name, value)
      mailer_instance.instance_eval("@#{klass_name.downcase}= #{klass_name.constantize}.find(#{value})")
    end

    def set_instance_for_other(instance_name, value)
      set_instance_for_other_mialer_instance(self, instance_name, value)
    end


    def set_instance_for_other_mialer_instance(mailer_instance, instance_name, value)
      if value.is_a?(String)
        mailer_instance.instance_eval("@#{instance_name} = %|#{value}|")
      else
        mailer_instance.instance_eval("@#{instance_name}=#{value}")
      end
    end

    def return_active_record(klass_name, value)
      raise NotImplementedError.new "This isn't completed, not sure how to set it up"
      return self.instance_eval("#{klass_name.constantize}.find(#{value})")
    end

    def return_other_object(klass_name, value)
      raise NotImplementedError.new "This isn't completed, not sure how to set it up"
      if value.is_a?(String)
        return self.instance_eval("%|#{value}|")
      else
        return self.instance_eval(":#{instance_name} => #{value}")
      end

    end

  end
end
