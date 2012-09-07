require 'spec_helper'

describe "circuit pages" do

	subject { page }

	#let(:bud) { FactoryGirl.create(:bud) }
	#let(:circuit) { bud.circuits.build(name: "Lorem ipsum", location: 0.0, side: 0) }
	bud = Bud.find_by_id(1)
	circuit = bud.circuits.first

	describe "new" do
		before(:each) { visit new_bud_circuit_path(bud, circuit) }

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
		      	visit bud_path(bud)
		      	should have_content(new_name)
	    	end
	    end
	end

	describe "edit" do
		before(:each) { visit edit_bud_circuit_path(bud, circuit) }
		let(:submit) { bud_circuit_path(bud, circuit) }

		it { should have_content(circuit.location) }
		it { should have_selector("form", method: "post", action: "bud/#{bud[:id]}/circuit/#{circuit[:id]}") }

		describe "with invalid information" do
			let(:new_name) { "" }
			before(:each) do
				fill_in 'circuit_name', with: new_name
				put submit, circuit_name: new_name
			end
			#temp
			pending { should have_content('failed') }
			pending { circuit.reload.name.should_not == new_name }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			before(:each) do
				fill_in 'circuit_name', with: new_name
				put submit, circuit_name: new_name
			end
			#temp
			pending { circuit.reload.name.should == new_name }
		end
	end

	describe "delete" do
		before(:each) { visit edit_bud_path(bud, circuit) }
		let(:submit) { "X" }

		it "should remove" do
			expect { click_button submit }.to change(Circuit, :count).by(-1)
		end
	end

	describe "show" do
		let(:bud) { FactoryGirl.create(:bud) }
		let(:circuit) { bud.circuits.build(name: "Lorem ipsum", location: 0.0, side: 0) }

		before(:each) { visit bud_path(bud) }

		it { should have_content(circuit.name) }
		it { should have_content(circuit.location) }
	end
end