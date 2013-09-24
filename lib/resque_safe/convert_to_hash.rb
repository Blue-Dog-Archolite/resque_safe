module ResqueSafe
  module ConvertToHash
    def translate_to_hash(args)
      th = {}

      args = args.flatten if args.respond_to?(:flatten)

      args.each do |arg|
        next if a.blank?
        if a.is_a?(Hash)
          a.each do|k,v|
            if v.respond_to?(:gsub)
              th[k.to_sym] = CGI.escapeHTML(v)
            else
              th[k.to_sym] = v
            end
          end
        elsif known_models.include?(a.class.name) || a.class.respond_to?(:column_names)
          th[a.class.name.underscore.to_sym] = a.id
        else
          raise ArgumentError.new("Unknown #{a.class} passed to resque safe. \n Object #{a.inspect} \n\n Args #{args} \n\n Known Models #{known_models}")
        end
      end
      th
    end
  end
end
