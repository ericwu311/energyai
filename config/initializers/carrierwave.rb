CarrierWave.configure do |config|
	config.permissions = 0666
	# config.directory_permissions = 0777
	config.storage = :file
	if Rails.env.test? or Rails.env.cucumber?
	  	config.enable_processing = false
	  	config.storage = :file
	end
end
