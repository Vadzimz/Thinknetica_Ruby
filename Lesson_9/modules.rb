# frozen_string_literal: true

module Manufacturer
  attr_accessor :manufacturer
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*attrs)
      
      attrs.each do |attr|
        at, at_h = "@#{attr}", "@#{attr}_history"

        define_method(attr) { instance_variable_get(at) }

        define_method("#{attr}=") do |val, history = []|
          instance_variable_set(at, val)
          history << instance_variable_get(at)
          instance_variable_set(at_h, history)
        end
        
        define_method("#{attr}_history") { instance_variable_get(at_h) }
      end
    end

    def strong_attr_accessor(attr, cls)
      define_method(attr) { instance_variable_get("@#{attr}") }
      define_method("#{attr}=") do |val| val.is_a?(cls) ? instance_variable_set("@#{attr}", val) : super
        rescue 
          puts "The attribute type should be #{cls}" 
        end
    end
  end
end

module Validation
  
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods

  def validate(attr, type, extra = nil)
    define_method "validate_#{type}" do
      at = instance_variable_get("@#{attr}")
      case type
      when :presence
        raise("The attribube should not be nil or empty") if at.nil? || at.to_s.empty?
      when :format
        raise("The attribute dosn't match the defined format") unless at =~ extra
      when :type
        raise("The attribute's type is not #{extra}") unless at.is_a? extra
      end
    end
    end
  end

  module InstanceMethods

    def validate!
      methods.grep(/^validate_/).each { |m| send(m) }
    end

    def valid?
      validate!
    rescue StandardError
      false
    end
  end
end
