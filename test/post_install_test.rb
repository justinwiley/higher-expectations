# designed to be executed post installing to site gem library
require 'higher_expectations'
class Universe
  include HigherExpectations
  
  def spin(direction)
    has_expectations(direction)
    direction.must_not_be_nil
  end
end

u = Universe.new
puts "Spinning"
u.spin(1)
puts "Spinning complete"
u.spin(nil)