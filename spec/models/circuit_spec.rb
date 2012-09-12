# == Schema Information
#
# Table name: circuits
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bud_id     :integer
#  location   :float
#  side       :integer
#

require 'spec_helper'

describe Circuit do
	let(:bud) { FactoryGirl.create(:bud) }
	before { @circuit = bud.circuits.build(name: "Lorem ipsum", location: 0.0, side: 0) }

	subject { @circuit }

	it { should respond_to(:name) }
  it { should respond_to(:location) }
  it { should respond_to(:side) }
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
    	before { @circuit.bud_id = nil }
    	it { should_not be_valid }
  	end
end
