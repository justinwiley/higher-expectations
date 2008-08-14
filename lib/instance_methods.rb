##
#
#  instance_methods.rb
#  Copyright 2008 Justin Tyler Wiley - see license for details
#
module HigherExpectations
  module InstanceMethods
    # must_X functions raise the traditional "ArgumentException", this exception is for programic errors when using HigherExpectations
    class HigherExpectationException < Exception; end;
    
    # defines must_be and must_not_be nil, true, false
    [true, false].each do |value|
      send :define_method, "must_be_#{value.to_s}".to_sym, lambda {
        raise_ae(" to be #{value.to_s}") unless self == value; self;
      }
      send :define_method, "must_not_be_#{value.to_s}".to_sym, lambda {
        raise_ae(" to be #{value.to_s}") unless self != value; self;
      }
    end
    
    # value must be nil, or must not be nil respectively
    def must_be_nil; raise_ae(" to be nil") unless self == nil; end;
    alias :and_must_be_nil :must_be_nil
    def must_not_be_nil; raise_ae(" to be nil") unless self != nil; end;
    alias :and_must_not_be_nil :must_not_be_nil
    
    # raise ArgumentError exception
    def raise_ae(message)
      raise ArgumentError.new("Method expects this argument" + message.to_s)
    end
    
    # argument must be the given value
    def must_be(*values)
      values.each {|value| raise_ae(" must equal #{value}") unless self == value; } 
      self   # allow for method concatonation "foo.must_be(String).and_must_not_be_nil
    end
    alias :and_must_be :must_be
    
    # argument must NOT be the given value
    def must_not_be(*values)
      values.each {|value| raise_ae(" must NOT equal #{value}") unless self != value; } 
      self
    end
    alias :and_must_not_be :must_not_be
    
    # value(s) must be a specific class or in given set of classes
    def must_be_a(*klasses)
      klasses.each do |klass|
        raise_ae(" should be #{klass.to_s}") unless self.kind_of?(klass)
      end
      self
    end
    alias :must_be_an :must_be_a


    
    # value(s)  must not be in a specific class or set of klasses
    def must_not_be_a(*klasses)
      klasses.each do |klass|
        raise_ae(" should NOT be #{klass.to_s}") if self.kind_of?(klass)
      end
      self
    end
    alias :must_not_be_an :must_not_be_a
    alias :and_must_not_be_a :must_not_be_a
    alias :and_must_not_be_an :must_not_be_a

    # value(s)  must be in a specific numeric range
    def must_be_in_range(range)
      raise HigherExpectationException.new("Must pass in two values ('foo.must_be_in_range(0,5)')") unless range.kind_of?(Range) || range.kind_of?(Array)
      raise_ae("'s value to be in the range of #{range.first} to #{range.last} (it was #{self.to_s})") unless self >= range.first && self <= range.last
      self
    end
    alias :and_must_be_in_range :must_be_in_range
    
    # value(s)  must be in a specific numeric range
    def must_not_be_in_range(range)
      raise HigherExpectationException.new("Must pass in two values ('foo.must_be_in_range(0,5)')") unless range.kind_of?(Range) || range.kind_of?(Array)
      raise_ae("'s value NOT to be in the range of #{range.first} to #{range.last} (it was #{self.to_s})") if self >= range.first && self <= range.last
      self
    end
    alias :and_must_not_be_in_range :must_not_be_in_range
    
    def must_match(pattern)
      raise_ae(" to match pattern #{pattern.to_s}") unless self =~ pattern
      self
    end
    alias :and_must_match :must_match

    def must_not_match(pattern)
      raise_ae(" to match pattern #{pattern.to_s}") if self =~ pattern
      self
    end
    alias :and_must_not_match :must_not_match
    
    def must_respond_to(*meths)
      meths.each do |meth|
        raise_ae(" to respond to #{meth}") unless self.respond_to?(meth.to_s)
      end
      self
    end
    alias :and_must_respond_to :must_respond_to
    
    def must_not_respond_to(*meths)
      meths.each do |meth|
        raise_ae(" to respond to #{meth}") if self.respond_to?(meth.to_s)
      end
      self
    end
    alias :and_must_not_respond_to :must_not_respond_to
  end
end