require 'spec_helper'

describe Circuit do
	let(:bud) { FactoryGirl.create(:bud) }
  let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }

	subject { circuit }

	it { should respond_to(:name) }
  it { should respond_to(:channel) }
  it { should respond_to(:bud_id) }
  it { should respond_to(:bud) }
  its(:bud) { should == bud }
	it { should be_valid }

	describe "accessible attributes" do
    	it "should not allow access to bud_id" do
      		expect do
        		Circuit.new(bud_id: bud.id)
      		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    	end    
  	end

	describe "when bud_id is not present" do
    	before { circuit.bud_id = nil }
    	it { should_not be_valid }
  	end
end
