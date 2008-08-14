$:.unshift File.dirname(__FILE__)
require 'rubygems'
require 'instance_methods'

##
#  Higher expectations module
#  Provides method to load instance methods in a group of arguments
#  Requires instance methods
#
#  Usage:
#
#  class Something
#    include HigherExpectations
#  end
#  ..or optionally inject into Object (not recommended)
#
module HigherExpectations
  VERSION = '0.1.0'

  # Should be called at method entrance
  # instead of spaming up entire Object class method space, extend each given object with expectation methods
  def has_expectations(*objects)
    objects.map do |obj|
      begin
        obj.extend(HigherExpectations::InstanceMethods)
      # TypeErrors are generated when trying to extend Numeric objects, which are not and cannot be singeltons and hence cannot get new methods.  
      # Handled below via Numeric
      rescue TypeError
        next    
      end
    end
  end
  alias :has_expectation :has_expectations
end

# Provides instance methods for Fixnum class, which due to limitiations mentioned above must be treated as a special case
class Fixnum; include HigherExpectations::InstanceMethods; end;