module SimplerEnum
  class Generator
    def initialize(klass, enum_name, enum_values)
      @klass = klass
      @enum_name = enum_name
      @enum_values = enum_values
    end

    def execute!
      define_read_enum_values_method_to_class!

      define_read_attribute_to_instance!
      define_write_attribute_to_instance!

      define_read_enum_value_method_to_instance!
      define_write_enum_value_method_to_instance!

      @enum_values.each do |key, _|
        define_query_enum_state_method_to_instance!(key)
        define_change_enum_state_method_to_instance!(key)
      end
    end

    private

    def define_read_enum_values_method_to_class!
      @klass.class_exec(@enum_name.to_s.pluralize, @enum_values) do |pluralized_name, enum_values|
        instance_variable_set("@#{pluralized_name}", enum_values)
        define_singleton_method pluralized_name do
          instance_variable_get "@#{pluralized_name}"
        end
      end
    end

    def define_write_attribute_to_instance!
      @klass.class_eval do
        define_method :write_attribute do |key, val|
          super rescue instance_variable_set("@#{key}", val) # rubocop:disable Style/RescueModifier
        end
      end
    end

    def define_read_attribute_to_instance!
      @klass.class_eval do
        define_method :read_attribute do |key|
          super rescue instance_variable_get("@#{key}") # rubocop:disable Style/RescueModifier
        end
      end
    end

    def define_read_enum_value_method_to_instance!
      @klass.class_exec(@enum_name) do |enum_name|
        define_method "#{enum_name}" do
          value = read_attribute(enum_name)
          self.class.public_send(enum_name.to_s.pluralize.to_sym).key(value)
        end
      end
    end

    def define_write_enum_value_method_to_instance!
      @klass.class_exec(@enum_name) do |enum_name|
        define_method "#{enum_name}=" do |value|
          next_value =
            if value.is_a?(Symbol)
              self.class.public_send(enum_name.to_s.pluralize.to_sym)[value]
            else
              value
            end
          write_attribute(enum_name, next_value)
        end
      end
    end

    def define_query_enum_state_method_to_instance!(value_name)
      @klass.class_exec(@enum_name) do |enum_name|
        define_method "#{value_name}?" do
          current_value = read_attribute(enum_name)
          current_value == self.class.public_send(enum_name.to_s.pluralize.to_sym)[value_name]
        end
      end
    end

    def define_change_enum_state_method_to_instance!(value_name)
      @klass.class_exec(@enum_name) do |enum_name|
        define_method "#{value_name}!" do
          next_value = self.class.public_send(enum_name.to_s.pluralize.to_sym)[value_name]
          write_attribute(enum_name, next_value)
          public_send(enum_name)
        end
      end
    end
  end
end
