# For full unit tests see spec directory
# Small designed to be executed post installing to site gem library to check general operation
require 'higher_expectations'
class Universe
  include HigherExpectations
  def spin(direction, velocity)
    has_expectations(direction, velocity)
    direction.must_not_be_nil
    velocity.must_be_a(SuperFloat).and_must_respond_to(:vector7)
  end
end
class SuperFloat; def vector7; end; end;

u = Universe.new
puts "Spinning"
u.spin(1, SuperFloat.new)
puts "Spinning complete"
begin
  u.spin(nil, Float.new)
rescue Exception
  puts "Exceptions raised where appropriate"
end