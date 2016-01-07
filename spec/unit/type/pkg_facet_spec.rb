#!/usr/bin/env rspec

require 'spec_helper'
require_relative  '../../../lib/puppet/type/pkg_facet'

describe Puppet::Type.type(:pkg_facet) do

  before do
    @class = described_class
    @profile_name = "rspec profile"
  end

  it "should have :name as its keyattribute" do
    @class.key_attributes.should == [:name]
  end

  describe "when validating attributes" do
    [:ensure, :value].each do |prop|
      it "should have a #{prop} property" do
        @class.attrtype(prop).should == :property
      end
    end
  end

  describe "when validating values" do

    describe "for ensure" do
      error_pattern = /Invalid value/m
      def validate(ens)
         @class.new(:name => @profile_name, :ensure => ens)
      end

      [ "present", "absent" ].each do |newval|
        it "should accept a value of #{newval}" do
          proc { validate(newval) }.should_not raise_error
        end
      end

      it "should reject invalid values" do
        proc { validate "foo" }.should raise_error Puppet::Error, error_pattern
      end
    end  # ensure

    describe "for value" do
      error_pattern = /Invalid value/m
      def validate(val)
         @class.new(:name => @profile_name, :value => val)
      end

      [ "true", "false", "none", "True", "False", "None" ].each do |newval|
        it "should accept a value of #{newval}" do
          proc { validate(newval) }.should_not raise_error
        end
      end

      it "should reject invalid values" do
        proc { validate "foo" }.should raise_error Puppet::Error, error_pattern
      end
    end  # value

  end # validating values
end