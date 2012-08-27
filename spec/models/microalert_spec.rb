# == Schema Information
#
# Table name: microalerts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  vocal_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vocal_type :string(255)
#


require 'spec_helper'

describe Microalert do

	let(:user) { FactoryGirl.create(:user) }
	let(:building) { FactoryGirl.create(:building) }

	before do
		@microalert = user.microalerts.build(content: "Lorem ipsum")
		@building_alert = building.microalerts.build(content: "Howdy doody")
	end

	describe "when Microalert is from a User" do
		subject { @microalert }

		it { should respond_to(:content) }
		it { should respond_to(:vocal_id) }
		it { should respond_to(:vocal_type) }
		it { should respond_to(:vocal) }
		its(:vocal) { should == user }
		it { should be_valid }

		describe "accessible attributes" do
			it "should not allow access to vocal_id" do
				expect do 
					Microalert.new(vocal_type: "user", vocal_id: user.id)
				end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
			end
		end

		describe "when vocal_id is not present" do
			before { @microalert.vocal_id = nil }
	        it { should_not be_valid }
		end

		describe "when content is blank" do 
			before { @microalert.content = " " }
			it { should_not be_valid }
		end

		describe "with content that is too long" do
			before { @microalert.content = "a" * 141 }
			it { should_not be_valid }
		end
	end

	describe "when Microalert is from a Building" do
		subject { @building_alert }

		it { should respond_to(:content) }
		it { should respond_to(:vocal_id) }
		it { should respond_to(:vocal_type) }
		it { should respond_to(:vocal) }
		its(:vocal) { should == building }
		it { should be_valid }

		describe "accessible attributes" do
			it "should not allow access to vocal_id" do
				expect do 
					Microalert.new(vocal_type: "building", vocal_id: building.id)
				end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
			end
		end

		describe "when vocal_id is not present" do
			before { @microalert.vocal_id = nil }
	        it { should_not be_valid }
		end

		describe "when content is blank" do 
			before { @microalert.content = " " }
			it { should_not be_valid }
		end

		describe "with content that is too long" do
			before { @microalert.content = "a" * 141 }
			it { should_not be_valid }
		end
	end
end
