module ApplicationHelper

	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Energy.AI"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	# Returns an id for labeling the background.
	def label_pageid(page_title)
		default_id = ""
		if page_title.empty?
			default_id
		else
			#remove spaces and downcase
			"id=#{page_title.gsub(/ /, '').downcase}-page"
		end
	end

	# determine whether to skip the header and footer links.
	def skip_header?(page_title)
		if page_title == "Sign in"
			true
		else
			false
		end
	end

	def skip_footer?(page_title)
		if page_title == "Sign in"
			true
		else
			false
		end
	end

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new #this generates a new object of klass bud
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s + "/" + association.to_s.singularize + "connect_fields", f: builder)
		end
		link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

end

