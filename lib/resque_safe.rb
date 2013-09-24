require 'resque_safe/convert_to_hash'
require 'resque_safe/convert_from_hash'
require 'resque_safe/util'

module ResqueSafe
  extend Util
  extend ConvertFromHash
  extend ConvertToHash
end
