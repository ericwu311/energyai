require 'spec_helper'

describe Item do
  	let(:bud) { FactoryGirl.create(:bud) }
  	let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }
  	let(:item) { FactoryGirl.create(:item, circuit: circuit) }

	subject { item }

	it { should respond_to(:name) }
	it { should respond_to(:status) }
	it { should respond_to(:count) }
  	it { should respond_to(:circuit_id) }
  	it { should respond_to(:circuit) }
  	its(:circuit) { should == circuit }
	it { should be_valid }

	describe "accessible attributes" do
    	it "should not allow access to circuit_id" do
      		expect do
        		Item.new(circuit_id: circuit.id)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    	end    
  	end

	describe "when circuit_id is not present" do
    	before { item.circuit_id = nil }
    	it { should_not be_valid }
  	end

  	describe "when name is not present" do
    	before { item.name = nil }
    	it { should_not be_valid }
  	end

  	describe "when status is not present" do
    	before { item.status = nil }
    	it { should_not be_valid }
  	end
end
