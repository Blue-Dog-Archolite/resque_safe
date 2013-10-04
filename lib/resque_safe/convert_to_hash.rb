module ResqueSafe
  module ConvertToHash
    def translate_to_hash(*args)
      th = {}

      args = args.flatten if args.respond_to?(:flatten)

      args.each do |arg, index|
        next if arg.blank?
        arg_class = arg.class.name
        if arg.is_a?(Hash)
          arg.each do|k,v|
            if v.respond_to?(:gsub)
              th[k.to_sym] = CGI.escapeHTML(v)
            else
              th[k.to_sym] = v
            end
          end
        elsif known_models.include?(arg_class) || arg.class.respond_to?(:column_names)
          th[arg_class.underscore.to_sym] = arg.id
        elsif arg.is_a?(String)
          th[index] = v
        else
          raise ArgumentError.new("Unknown #{arg_class} passed to resque safe. \n Object #{arg.inspect} \n\n Args #{args} \n\n Known Models #{known_models}")
        end
      end
      th
    end
  end
end
