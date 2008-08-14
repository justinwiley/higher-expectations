require File.dirname(__FILE__) + '/spec_helper'
class DummyClass
  include HigherExpectations
end

describe "HigherExpectations" do
  include HigherExpectations
  it "should not raise an exception when included" do
    lambda { include HigherExpectations }.should_not raise_error
  end
  describe "#has_expectations" do
    before(:each) do
      @number = 1
      @string = "foobar"
      @dummy = DummyClass.new
    end
    
    it "should loop through given objects, extending each with instance_expectations.rb methods" do
      #include HigherExpectations
      has_expectations(@number, @string, @custom_object)
      @number.should respond_to(:must_be_nil)
      @string.should respond_to(:must_be_nil)
      @string.should respond_to(:must_be_nil)
      @string.should_not respond_to(:blah_blah)
    end
  end
end