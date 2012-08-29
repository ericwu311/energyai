require 'spec_helper'

describe "StaticPages" do
	
	let (:base_title) { "Verdigristech Energy.AI" }
	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('img', alt: heading) }
		it { should have_selector('title', text: full_title(page_title)) }
	end

	describe "Home Page and Sign in" do
		#before(:each) { visit root_path }
		before(:each) { visit root_path }
		let(:heading) { 'Energy.AI' }
		let(:page_title) { 'Sign in' }

		it_should_behave_like "all static pages"
		
		# all the right links should exist in the footer
		it { should have_link("About Verdigris", href: aboutus_path) }
	    it { should have_link("Help", href: help_path) }
		it { should have_link("Blog", href: blog_path) }
	    it { should have_link("Terms", href: terms_path) }
	    
	    it { should have_link("Sign up", href: signup_path) } 
	    it { should_not have_selector('header') } 
	    it { should_not have_selector('footer') }  	
		it { should have_link("Sign in with Google Account", href: '#') }
		# it should have normal signin form
		it { should have_content('Email')}
		it { should have_content('Password')}
	end

	describe "Home Page" do

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
        		FactoryGirl.create(:microalert, vocal: user, content: "Lorem ipsum")
        		FactoryGirl.create(:microalert, vocal: user, content: "Dolor sit amet")
        		sign_in user
        		visit root_path
        	end

			describe "sidebar should pluralize properly" do
        		it { should have_content(user.microalerts.count) }
        		it { should have_content("2 alerts") }
            end

        	it "should render the user's feed" do
        		user.feed.each do |item|
        			page.should have_selector("li##{item.id}", text: item.content)
        		end
        	end

        	describe "follower/following counts" do
        		let(:other_user) { FactoryGirl.create(:user) }
        		before do
        			other_user.follow!(user)
        			visit root_path
        		end

        		it { should have_link("0 following", href: following_user_path(user)) }
        		it { should have_link("1 followers", href: followers_user_path(user)) }
        	end
        end
    end






end
