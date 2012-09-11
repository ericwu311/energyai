module BuildingsHelper

	def avatar_for(building, options = { size: 50 })
		vatar_id = Digest::MD5::hexdigest("#{building.name.downcase}#{building.address.downcase}")
		size = options[:size]
		# avatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		# image_tag(gravatar_url, alt: user.name, class: "gravatar thumbnail")
	end
end
