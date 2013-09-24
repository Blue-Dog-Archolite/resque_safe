require 'resque_safe/convert_to_hash'
require 'resque_safe/convert_from_hash'
require 'resque_safe/util'

module ResqueSafe
  include Util
  extend ConvertFromHash
  extend ConvertToHash
end
