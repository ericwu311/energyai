FactoryGirl.define do
	factory :user, aliases: [:creator] do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "Person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"
		default_building_id ""

		factory :admin do
			admin true
		end
	end	

	factory :bud do
		sequence(:name)  { |n| "Bud #{n}" }
		sequence(:uid)  { |n| "U #{n}" }
		hardware_v "1.0"
		firmware_v "1.0"
		association :building, factory: :building
	end	

	factory :circuit do
		sequence(:name) { |n| "Circuit #{n}" }
		sequence(:channel)  { |n| n }
		active true
		association :bud, factory: :bud
	end

	factory :item do
		sequence(:name) { |n| "Item #{n}" }
		status "live"
		count 1
		association :circuit, factory: :circuit
	end

	factory :microalert do
		#content = Faker::Lorem.sentence(5) doesn't work in rspec environment
		sequence(:content) { |n| "Lorem Ipsum #{n}" }
		association :vocal, factory: :user
	end

	factory :building do
		sequence(:name)  { |n| "Building #{n}" }
		sequence(:address) { |n| "123 Builing_#{n} ST, Moffett Field, CA 94035" }
		association :creator, factory: :user
	end			
end