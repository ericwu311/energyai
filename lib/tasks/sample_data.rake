namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
	    make_users
	    make_microalerts
	    make_user_user_relationships
	    make_buds
        make_circuits
        make_items
	    make_buildings
	    make_building_microalerts
        make_user_building_relationships
        make_building_relationships
	end
end

def make_users
	admin = User.create!(name: "Luke",
		                 email: "luke@email.com",
		                 password: "foobar",
		                 password_confirmation: "foobar")
    admin2 = User.create!(name: "Mark Chung",
                         email: "mark.y.chung@gmail.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    admin2.toggle!(:admin)
    35.times do |n|
    	name  = Faker::Name.name
    	email = "example-#{n+1}@railstutorial.org"
    	password = "password"
    	User.create!(name: name,
    				 email: email,
    				 password: password,
	    			 password_confirmation: password)
    end
end

def make_buds
	35.times do |n|
    	name  = Faker::PhoneNumber.phone_number
    	uid = "#{n+1}"
    	hardware_v = "1.0"
    	firmware_v = "1.0"
    	Bud.create!(name: name,
    				 uid: uid,
    				 active: true,
    				 hardware_v: hardware_v,
	    			 firmware_v: firmware_v)
    end
end

def make_circuits
    buds = Bud.all(limit: 5)
    buds.each do |bud|
        4.times do |n|
            bud.circuits.create!(name: "Circuit L#{n}",
            					 channel: n+3,
            					 active: true)
        end
        4.times do |n|
            bud.circuits.create!(name: "Circuit R#{n}",
            					 channel: n+32,
            					 active: true)
        end
    end
end

def make_items
	circuits = Circuit.all(limit: 10)
	circuits.each do |circuit|
		2.times do |n|
			name = Faker::Lorem.words(num = 1)
			circuit.items.create!(name: name,
								  status: "ON",
								  count: 1)
		end
	end
end

def make_microalerts
    users = User.all(limit: 6)
    35.times do
    	content = Faker::Lorem.sentence(5)
    	users.each { |user| user.microalerts.create!(content: content)}
    end
end	

def make_user_user_relationships
	users = User.all 
	user = users.first
    user2 = users[1]
	followed_users = users[2..50]
	followers      = users[3..40]
	followed_users.each do |followed|
        user.follow!(followed) 
        user2.follow!(followed)
    end
	followers.each      do |follower| 
        follower.follow!(user) 
        follower.follow!(user2)
    end
end

def make_buildings
	user = User.first
    user2 = User.find_by_name("Mark Chung")
	building = user.buildings.create!(name: "NASA Ames Building 19",
		                 address: "NASA Ames Research Park, Moffett Field, CA, 94035")
    20.times do |n|
    	name  = Faker::Company.name
    	street_address = Faker::Address.street_address
    	city = Faker::Address.city
    	state = Faker::Address.state_abbr
    	zip = Faker::Address.zip
    	user.buildings.create!(name: name,
    				 address: "#{street_address} #{city}, #{state} #{zip}")
    end
    20.times do |n|
        name  = Faker::Company.name
        street_address = Faker::Address.street_address
        city = Faker::Address.city
        state = Faker::Address.state_abbr
        zip = Faker::Address.zip
        user2.buildings.create!(name: name,
                     address: "#{street_address} #{city}, #{state} #{zip}")
    end
end

def make_building_microalerts
    buildings = Building.all(limit: 6)
    50.times do
    	content = Faker::Lorem.sentence(5)
    	buildings.each { |building| building.microalerts.create!(content: content)}
    end
end	

def make_user_building_relationships
    users = User.all
    buildings = Building.all 
    user = users.first
    user2 = users[1]
    followed_buildings = buildings[2..25]
    followers      = buildings[3..30]
    followed_buildings.each do |followed|
        user.follow!(followed) 
        user2.follow!(followed)
    end
    followers.each      do |follower|
        follower.follow!(user) 
        follower.follow!(user2)
    end
end

def make_building_relationships
    buildings = Building.all 
    building = buildings.first
    followed_buildings = buildings[2..50]
    followers      = buildings[3..30]
    followed_buildings.each { |followed| building.follow!(followed) }
    followers.each      { |follower| follower.follow!(building) }
end
