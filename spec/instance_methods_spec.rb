require File.dirname(__FILE__) + '/spec_helper'
class Dummy
  attr_accessor :value
end

#
# Todo: a clever implementation that DRYs up the below, while leaving it readable and producing a decent specdoc
#
describe "HigherExpectation::InstanceMethods" do
  include HigherExpectations
  before(:each) do
    @number = 1
    @string = "la la la"
    @date = DateTime.new
    @dummy = Dummy.new
    @true = true
    @false = false
    @nil = nil
    has_expectations(@number, @string, @dummy, @date, @negation)
  end
  
  describe "#raise_ae" do
    it "should raise an ArgumentException with the given message" do
      lambda{ @negation.raise_ae("foobar") }.should raise_error(ArgumentError)
    end
  end
  
  describe "#must_be_/must_not_be_ - true, false, and nil" do
    it "should raise exception if expected to be true false or nil, and they are not" do
      ["true","false","nil"].each do |x|
        method = "must_be_#{x}".to_sym
        lambda{ @string.send(method) }.should raise_error(ArgumentError)
      end
    end
    
    it "should not raise exception if expected to be true false or nil, and they are" do
      ["true","false","nil"].each do |x|
        method = "must_not_be_#{x}".to_sym
        lambda{ @string.send(method) }.should_not raise_error(ArgumentError)
      end
    end
  end
  
  describe "#must_be and must_not_be a particular value" do
    it "should raise exception if item must be something and isnt" do
      lambda{ @dummy.must_be(1) }.should raise_error(ArgumentError)
    end
    
    it "should not raise exception if item must be something and IS" do
      @dummy = 1
      lambda{ @dummy.must_be(1) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should raise exception if item must not be something and IS" do
      @dummy = 1
      lambda{ @dummy.must_not_be(1) }.should raise_error(ArgumentError)
    end
    
    it "(#not) should not raise exception if item must not be something and is not" do
      lambda{ @dummy.must_not_be(1) }.should_not raise_error(ArgumentError)
    end
  end
  
  describe "#must_be_a and must_not_be_a particular class of object" do
    it "should raise exception if item must be a class and isnt" do
      lambda{ @dummy.must_be_a(Integer) }.should raise_error(ArgumentError)
    end
    
    it "should not raise exception if item must be a class and IS" do
      lambda{ @dummy.must_be_a(Dummy) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should raise exception if item must not be a class and is not" do
      lambda{ @dummy.must_not_be_a(Integer) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should not raise exception if item must not be a class and IS" do
      lambda{ @dummy.must_not_be_a(Dummy) }.should raise_error(ArgumentError)
    end
  end
  
  describe "#must_be_in_range and must_not_be_in_range of numbers" do
    it "should raise exception if item must be in a range and isnt" do
      @dummy = 0
      lambda{ @dummy.must_be_in_range(1..12) }.should raise_error(ArgumentError)
      @dummy = 13
      lambda{ @dummy.must_be_in_range(1..12) }.should raise_error(ArgumentError)
      lambda{ @dummy.must_be_in_range(1..12) }.should raise_error(ArgumentError)  # no value
    end
    
    it "should not raise exception if item must be in a range and is" do
      @dummy = 1
      @dummy.must_be_in_range(1..12)
      lambda{ @dummy.must_be_in_range(1..12) }.should_not raise_error(ArgumentError)
      @dummy = 5
      lambda{ @dummy.must_be_in_range(1..12) }.should_not raise_error(ArgumentError)
      @dummy = 12
      lambda{ @dummy.must_be_in_range(1..12) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should raise exception if item in a range" do
      @dummy = 1
      lambda{ @dummy.must_not_be_in_range(1..12) }.should raise_error(ArgumentError)
    end
    
    it "(#not) should not raise exception if item not in range" do
      @dummy = 0
      lambda{ @dummy.must_not_be_in_range(1..12) }.should_not raise_error(ArgumentError)
    end
    
    it "should raise HigherExpectation exception if handed something besides and array or a range" do
      lambda{ @dummy.must_not_be_in_range("invalid") }.should raise_error
    end
  end
  
  describe "#must_match and must_not_match a given pattern" do
    it "should raise exception if item does not match" do
      lambda{ @string.must_match(/le/) }.should raise_error(ArgumentError)
    end
    
    it "should not raise exception if item matches" do
      lambda{ @string.must_match(/la/) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should not raise exception if item does not match" do
      lambda{ @string.must_not_match(/le/) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should raise exception if item matches" do
      lambda{ @string.must_not_match(/la/) }.should raise_error(ArgumentError)
    end
  end
  
  describe "#must_respond_to and must_not_respond_to a given method" do
    it "should raise exception if item does not respond" do
      lambda{ @string.must_respond_to(:nuts) }.should raise_error(ArgumentError)
    end
    
    it "should not raise exception if item respond" do
      lambda{ @string.must_respond_to(:to_s) }.should_not raise_error(ArgumentError)
    end
    
    it "(#not) should raise exception if item responds" do
      lambda{ @string.must_not_respond_to(:to_s) }.should raise_error(ArgumentError)
    end
    
    it "(#not) should not raise exception if does respond" do
      lambda{ @string.must_not_respond_to(:nuts) }.should_not raise_error(ArgumentError)
    end
  end
end
