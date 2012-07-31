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
			"id=#{page_title}-page"
		end
	end

	# determine whether to skip the header and footer links.
	def skip_header?(page_title)
		if page_title == "Login"
			true
		else
			false
		end
	end

	def skip_footer?(page_title)
		if page_title == "Login"
			true
		else
			false
		end
	end

end

