$:.unshift File.dirname(__FILE__)
require 'instance_methods'
require 'rubygems'

##
#  
#
module HigherExpectations
  VERSION = '0.1.0'

  # Called at method entrance
  # instead of spaming up entire Object class method space, extend each given object with expectation methods
  def has_expectations(*objects)
    objects.map do |obj|
      begin
        obj.extend(InstanceMethods)
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
class Fixnum; include InstanceMethods; end;