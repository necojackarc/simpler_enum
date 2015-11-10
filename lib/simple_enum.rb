require "active_support"
require "active_support/core_ext"
require "simple_enum/version"

module SimpleEnum
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def simple_enum(single_size_hash)
      fail ArgumentError if single_size_hash.size != 1

      name, enum_values = single_size_hash.first

      define_read_enum_values_method_to_class!(name.to_s.pluralize, enum_values)
      define_read_enum_value_method_to_instance!(name)
      define_write_enum_value_method_to_instance!(name)

      enum_values.each do |key, _|
        define_query_enum_state_method_to_instance!(name, key)
        define_change_enum_state_method_to_instance!(name, key)
      end
    end

    private

    def define_read_enum_values_method_to_class!(pluralized_name, enum_values)
      instance_variable_set("@#{pluralized_name}", enum_values)
      define_singleton_method pluralized_name do
        instance_variable_get "@#{pluralized_name}"
      end
    end

    def define_query_enum_state_method_to_instance!(enum_name, value_name)
      define_method "#{value_name}?" do
        current_value = instance_variable_get("@#{enum_name}")
        current_value == self.class.public_send(enum_name.to_s.pluralize.to_sym)[value_name]
      end
    end

    def define_change_enum_state_method_to_instance!(enum_name, value_name)
      define_method "#{value_name}!" do
        next_value = self.class.public_send(enum_name.to_s.pluralize.to_sym)[value_name]
        instance_variable_set("@#{enum_name}", next_value)
        public_send(enum_name)
      end
    end

    def define_read_enum_value_method_to_instance!(enum_name)
      define_method "#{enum_name}" do
        value = instance_variable_get("@#{enum_name}")
        self.class.public_send(enum_name.to_s.pluralize.to_sym).key(value)
      end
    end

    def define_write_enum_value_method_to_instance!(enum_name)
      define_method "#{enum_name}=" do |value|
        next_value =
          if value.is_a?(Symbol)
            self.class.public_send(enum_name.to_s.pluralize.to_sym)[value]
          else
            value
          end
        instance_variable_set("@#{enum_name}", next_value)
      end
    end
  end
end
