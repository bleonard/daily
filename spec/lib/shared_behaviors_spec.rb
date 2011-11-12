require 'spec_helper'

class SharedModelTest
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  extend ActiveModel::Callbacks
  
  include SharedBehaviors
  
  define_model_callbacks :validation
  define_attribute_methods ['guid', 'name']
  
  attr_accessor :guid, :name
  
  generate_guid :guid
  validates_stripped_presence_of :name
end

describe SharedModelTest do
  before do
    SharedModelTest.any_instance.stubs(:guid_generate).returns("1234")
    SharedModelTest.any_instance.stubs(:new_record?).returns(true)
  end
  
  describe "validates presence of" do
    it "should check" do
      model = SharedModelTest.new
      model.guid = "5678"
      model.name = "whatever"
      
      model.should be_valid
      
      model.name = ""
      model.should_not be_valid
      
      model.name = "  "
      model.should_not be_valid
      
      model.name = nil
      model.should_not be_valid
    end
  end
  
  describe "stripped behavior" do
    it "should strip the string value" do
      model = SharedModelTest.new
      model.name = "whatever  "
      model.run_callbacks(:validation)
      model.name.should == "whatever"
    end
    
    it "shouldn't mess with nil value" do
      model = SharedModelTest.new
      model.name = nil
      model.run_callbacks(:validation)
      model.name.should == nil
    end
    
    it "shouldn't mess with fine value" do
      model = SharedModelTest.new
      model.name = "abc"
      model.run_callbacks(:validation)
      model.name.should == "abc"
    end
  end
  
  describe "guid generation" do
    context "new record" do
      it "should generate a guid on create" do
        model = SharedModelTest.new
        model.guid.should be_nil
        model.run_callbacks(:validation)
        model.guid.should == "1234"
      end
      
      it "should not generate one if it has one" do
        model = SharedModelTest.new
        model.guid = "5678"
        model.run_callbacks(:validation)
        model.guid.should == "5678"
      end
      
      it "should be able to update guid" do
        model = SharedModelTest.new
        model.run_callbacks(:validation)
        model.guid.should == "1234"
        model.guid = "5678"
        model.run_callbacks(:validation)
        model.guid.should == "5678"
      end
      
      it "should append and prepend when asked to" do
        SharedModelTest.any_instance.stubs(:guid_append).returns("XYZ")
        SharedModelTest.any_instance.stubs(:guid_prepend).returns("ABC")
        model = SharedModelTest.new
        model.guid.should be_nil
        model.run_callbacks(:validation)
        model.guid.should == "ABC1234XYZ"
      end
    end
    
    context "saved record" do
      before do
        SharedModelTest.any_instance.stubs(:new_record?).returns(false)
      end
      
      it "should not generate one" do
        # SharedModelTest.any_instance.stubs(:new_record?).returns(false)
        model = SharedModelTest.new
        model.name = "fdjh"
        model.guid = ""
        model.run_callbacks(:validation)
        model.should_not be_valid
        model.errors.full_messages.should == ["Guid can't be blank"]
      end
    end
  end
end