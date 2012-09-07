require 'spec_helper'

describe "circuit pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:bud) { FactoryGirl.create(:bud) }
	let(:circuit) { FactoryGirl.create(:circuit, bud: bud) }

	before do
		sign_in user
		circuit.save
	end

	describe "new" do
		before(:each) { visit new_bud_circuit_path(bud) }
		let(:submit) { "Create" }

	  	describe "with invalid information" do
	  		it "should not create a circuit" do
	  			expect { click_button submit }.not_to change(Circuit, :count)
	  		end

	  		describe "after submission" do
	  			before { click_button submit }
	  			it { should have_content('error') }
	  			it { should have_content('can\'t be blank') }
	  		end
	  	end
 
 	  	describe "with valid information" do
 	  		let(:new_name) { "New Name" }

	  		before(:each) do
	  			fill_in 'circuit_name',  		with: new_name
	  			fill_in 'circuit_side',  		with: "0"
	  			fill_in 'circuit_location',  	with: "0.0"
		    end

			it "should create a circuit" do
		      	expect { click_button submit }.to change(Circuit, :count).by(1)
	    	end

	    	describe "after submission" do
	    		before do
	    			click_button submit
		      		visit bud_path(bud)
		      	end

		      	it { should have_content(new_name) }
	    	end
	    end
	end

	describe "edit" do
		before(:each) { visit edit_bud_path(bud, circuit) }

		it { should have_content(circuit.location) }
		it { should have_selector("input", value: circuit.name) }
		it { should have_selector("form", method: "post", action: "bud/#{bud[:id]}/circuit/#{circuit[:id]}") }

		describe "with invalid information" do
			let(:new_name) { "" }

			before(:each) do
				fill_in 'circuit_name', with: new_name
				click_button "submit"
			end

			it { should have_content('failed') }
			it { should have_selector("input", value: circuit.name) }
			specify { circuit.reload.name.should_not == new_name }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }

			before(:each) do
				fill_in 'circuit_name', with: new_name
				click_button "submit"
			end

			specify { circuit.reload.name.should == new_name }
			it { should have_selector("input", value: new_name) }
		end
	end

	describe "show" do

		before(:each) { visit bud_path(bud) }

		describe "should display" do
			before(:each) do
				circuit1 = Factory(:circuit, bud: bud)
				circuit1.bud=(bud)
				circuit1.save 
				bud.save
			end

			specify { bud.circuits.count.should eql(2) }
			it { should have_content(circuit.name) }
			it { should have_content(circuit.location) }
		end
	end

	describe "delete" do
		let(:submit) { "X" }

		before(:each) { visit edit_bud_path(bud, circuit) }

		it "should remove" do
			expect { click_button submit }.to change(Circuit, :count).by(-1)
		end

		describe "after submission" do
			before do
				click_button submit
			end

			#removal should leave no circuits, and no circuits to delete
			specify { bud.circuits.count.should eql(0) }
			it { should_not have_link("X") }
		end
	end
end