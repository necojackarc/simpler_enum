require "active_support"
require "active_support/core_ext"
require "simpler_enum/version"
require "simpler_enum/generator"

module SimplerEnum
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def simpler_enum(single_size_hash)
      fail ArgumentError if single_size_hash.size != 1

      enum_name, enum_values = single_size_hash.first
      SimplerEnum::Generator.new(self, enum_name, enum_values).execute!
    end
  end
end
