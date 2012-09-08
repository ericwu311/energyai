namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
	    make_users
	    make_microalerts
	    make_user_user_relationships
	    make_buds
        make_circuits
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
    admin.toggle!(:admin)
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
    				 hardware_v: hardware_v,
	    			 firmware_v: firmware_v)
    end
end

def make_circuits
    buds = Bud.all(limit: 6)
    f = 0
    n = 0
    s = 0
    16.times do
        if n >= 4 then
            n = 0
            if s == 1 then
                s = 0
                f+= 1
            else
                s = 1
            end
        end
        name = Faker::PhoneNumber.phone_number
        loc = (f)+(n*0.1)
        side = s
        buds.each { |bud| bud.circuits.create!(name: name,
                                                location: loc,
                                                side: side)}
        n += 1
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
	followed_users = users[2..50]
	followers      = users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each      { |follower| follower.follow!(user) }
end

def make_buildings
	user = User.first
	building = user.buildings.create!(name: "NASA Ames Building 19",
		                 address: "NASA Ames Research Park, Moffett Field, CA, 94035")
    40.times do |n|
    	name  = Faker::Company.name
    	street_address = Faker::Address.street_address
    	city = Faker::Address.city
    	state = Faker::Address.state_abbr
    	zip = Faker::Address.zip
    	user.buildings.create!(name: name,
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
    followed_buildings = buildings[2..25]
    followers      = buildings[3..30]
    followed_buildings.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
end

def make_building_relationships
    buildings = Building.all 
    building = buildings.first
    followed_buildings = buildings[2..50]
    followers      = buildings[3..30]
    followed_buildings.each { |followed| building.follow!(followed) }
    followers.each      { |follower| follower.follow!(building) }
end
