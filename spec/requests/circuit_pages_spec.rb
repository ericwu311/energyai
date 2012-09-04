require 'spec_helper'

describe "circuit pages" do

	subject { page }

	let(:bud) { FactoryGirl.create(:bud) }
	let(:circuit) { bud.circuits.build(name: "Lorem ipsum", location: 0.0, side: 0) }

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
	  		before(:each) do
	  			fill_in 'circuit_name',  		with: "Example Circuit"
	  			fill_in 'circuit_side',  		with: "0"
	  			fill_in 'circuit_location',  	with: "0.0"
		    end

			it "should create a circuit" do
		      	expect { click_button submit }.to change(Circuit, :count).by(1)
	    	end
	    end
	end

	describe "edit" do
		before(:each) { visit edit_bud_path(bud, circuit) }
		let(:submit) { edit_bud_path(bud, circuit) }

		it { should_receive(:render).with(partial: 'circuits/circuits_form') }

		#render 'circuits/circuits_form.html.erb'

		it { should have_content(circuit.name) }
		it { should have_content(circuit.location) }

		describe "with invalid information" do
			before(:each) do
				fill_in 'circuit_name', with: ""
				post submit
			end

			it "shouldn't save" do
				it { should have_content('error') }
	  			it { should have_content('can\'t be blank') }
			end
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			before(:each) do
				fill_in 'circuit_name', with: new_name
				submit
			end

			it "should save" do
				it { should have_content(new_name) }
			end
		end
	end

	describe "delete" do
		before(:each) { visit edit_bud_path(bud, circuit) }
		let(:submit) { "X" }

		it "should remove" do
			expect { click_button submit }.to change(Circuit, :count).by(-1)
		end
	end
end