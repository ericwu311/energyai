require 'spec_helper'

describe CircuitsController do

	describe "PUT 'update'" do
		let(:user) { FactoryGirl.create(:user) }
		let(:bud) { FactoryGirl.create(:bud) }
		let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }
		before do
			sign_in user
			circuit.save
		end

		describe "failure" do
			before(:each) do
				@attr = { circuit_name: ""}
			end
			it "should render the 'edit' page" do
				#bad put update call
    			put :update, id: circuit, circuit: @attr
    			response.should render_template(edit_bud_path(bud))
  			end
		end

		describe "success" do
			before(:each) do
				new_name = "New Name"
				@attr = { circuit_name: new_name}
			end
			it "should render the 'edit' page" do
				#bad put update call
    			put :update, id: circuit, circuit: @attr
    			response.should render_template(edit_bud_path(bud))
  			end
		end
	end
end