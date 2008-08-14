= higher_expectations

* http://higher_expectations.rubyforge

== DESCRIPTION:

Provides an easy and quick way to make sure method arguments are what you expect them to be.

You want to make sure that methods explode if they are given inappropriate inputs, but you don't want to deal with a complete design-by-contract implementation like RDBC.  Before you fire up the flame tank please note that I completely agree that this is nothing like a formal design-by-contract in any number of important ways.  It provides something -like- the "obligations" component of DBC.

So you are tired or writing stuff like:

def calc_sunrise(day, month, year, latitude, longitude, planet)
  raise Exception.new("day should be numeric and in the range of 1-32) unless day.kind_of?(Numeric) && day > 0 && day < 32
  ...etc. etc. for year, latitude, longitude, planet...
end

and you would rather write

def calc_sunrise(day, month)
  has_expectations(day, month)
  day.must_not_be(Numeric).and_must_be_in_range(0..5)
  month.must_be(Numeric)
  ...do other important stuff below...
end

== FEATURES/PROBLEMS:

* provides a set of usefull methods for determining what an object is at runtime, and raising an exception
* avoids creating these methods in Object directly, and instead extends the objects passed in (although it does add them directly to Numeric due to constraints in Ruby's Numeric implementation)
* allows for method changing and provides a dose of syntactic sugar

== SYNOPSIS:

Imagine you have a method buried deep within your wicked 1D planet simulator codebase.  Said codebase uses parameters passed in through the web and validated at various levels, but that doesn't necessarily mean that that particular method will be called with a sane value.  

For example:

def calc_sunrise(day, month)
  sunrise = (day - 50000)/month   # some arbitrary calculation that assumes day is a number and not negative
end

Joey your coworker hacks away and calls the method thusly:

PlanetEarth.sunrise = calc_sunrise(-5, 1)

Code executes, but earths sunrise changes to a weird value.  Hell freezes over, breaking the deeply subtly continuity of your whole world.  No amount of unit testing, specing, validating outside the model would have stopped Joey from making this hambone maneuver.

Now you could have said something like:

def calc_sunrise(day, month)
  raise ArgumentError.new("day must be numeric") unless day.kind_of?(Numeric)
  raise ArgumentError.new("day must be in range of 1-31") unless day > 1 && day < 31
  raise ArgumentError.new("month must be numeric") unless month.kind_of?(Numeric)
  raise ArgumentError.new("month must be in range of 1-31") unless month > 1 && day < 31  # note subtle bug
  raise ArgumentError.new("month must not be nil") unless month > 1 && month < 31
  ...sunrise calc...
end

Drudgery, duplication, error prone, etc. etc.  Wouldn't you like to do this instead?

include HigherExpectations  # somewhere in the class
def calc_sunrise(day, month)
    has_expectations(day, month)    # attach expectation methods to each object
    day.must_be(Numeric)            # day must be numeric or an exception will be raise
    day.must_be_in_range(1..31)     # day must be in range or exception
    month.must_be(Numeric).and_must_be_in_range(1..31)  # a neat combination of both
    month.must_be_nil rescue nil                        # since it raises an exception, its trappable, allowing for more flexible handling
  ...sunrise calc
end

...or even cleaner.

def calc_sunrise(day,month)
  has_expectations(day,month)
  *args.map{|a| a.must_be(Numeric).and_must_be_in_range(1..31)}
  month.must_be_nil
  ...sunrise calc...
end

See spec below for details on methods possible.

Copyright (c) 2008 Justin Tyler Wiley (justintylerwiley.com), under GPL V3

== SPEC:

HigherExpectations
- should not raise an exception when included

HigherExpectations#has_expectations
- should loop through given objects, extending each with instance_expectations.rb methods

InstanceMethods

InstanceMethods#raise_ae
- should raise an ArgumentException with the given message

InstanceMethods#must_be_/must_not_be_ - true, false, and nil
- should raise exception if expected to be true false or nil, and they are not
- should not raise exception if expected to be true false or nil, and they are

InstanceMethods#must_be and must_not_be a particular value
- should raise exception if item must be something and isnt
- should not raise exception if item must be something and IS
- (#not) should raise exception if item must not be something and IS
- (#not) should not raise exception if item must not be something and is not

InstanceMethods#must_be_a and must_not_be_a particular class of object
- should raise exception if item must be a class and isnt
- should not raise exception if item must be a class and IS
- (#not) should raise exception if item must not be a class and is not
- (#not) should not raise exception if item must not be a class and IS

InstanceMethods#must_be_in_range and must_not_be_in_range of numbers
- should raise exception if item must be in a range and isnt
- should not raise exception if item must be in a range and is
- (#not) should raise exception if item in a range
- (#not) should not raise exception if item not in range
- should raise HigherExpectation exception if handed something besides and array or a range

InstanceMethods#must_match and must_not_match a given pattern
- should raise exception if item does not match
- should not raise exception if item matches
- (#not) should not raise exception if item does not match
- (#not) should raise exception if item matches

InstanceMethods#must_respond_to and must_not_respond_to a given method
- should raise exception if item does not respond
- should not raise exception if item respond
- (#not) should raise exception if item responds
- (#not) should not raise exception if does respond

== REQUIREMENTS:

* hoe

== INSTALL:

* sudo gem install higher-expectations

== LICENSE:

Copyright (C) 2008 Justin Tyler Wiley

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>