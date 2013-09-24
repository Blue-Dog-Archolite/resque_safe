module ResqueSafe
  module Util
    def known_models
      @known_models if @known_models
      @known_models = ActiveRecord::Base.send( :descendants ).flatten.uniq
      @known_models += @known_models.collect{|sub_class| sub_class.send(:descendants) }.flatten.uniq
      @known_models.uniq!
      @known_models
    end
  end
end
