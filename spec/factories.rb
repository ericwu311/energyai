FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "Person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end	

	factory :bud do
		sequence(:name)  { |n| "Bud #{n}" }
		sequence(:uid)  { |n| "UID #{n}" }
		hardware_v "1.0"
		firmware_v "1.0"
	end	

	factory :microalert do
		#content = Faker::Lorem.sentence(5) doesn't work in rspec environment
		sequence(:content) { |n| "Lorem Ipsum #{n}" }
		association :vocal, factory: :user
	end

	factory :building do
		sequence(:name)  { |n| "Building #{n}" }
		sequence(:address) { |n| "123 Builing_#{n} ST, Moffett Field, CA 94035" }
	end		

	
end