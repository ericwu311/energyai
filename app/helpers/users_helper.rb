module UsersHelper
	# Returns the Gravatar (http://gravatar.com/) for a given user.
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar thumbnail")
	end

	# SMS mailto extensions.

# verizon: "vtext.com"
# att: "text.att.net"
# alltel: "message.alltel.com"
# sprint: "messaging.sprintpcs.com"
# uscellular: "email.uscc.net"
# tmobile: "tmomail.net"
# claro: "vtexto.com"			# Claro Puerto Rico
# nextel: "messaging.nextel.com"
# digicel: "digitextky.com"  # digicel Cayman
# cwmobile: "cwmobile.com"  #cable & Wireless mobile.
end
