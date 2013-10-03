module SessionHelper
	def get_image_tag(session)
		images = { "LiveSession" => "livestreaming.png", "ArticleSession" => "text.png", "VideoSession" => "video.png", "Announcement" => "announcement.png" }
		images[session.class.to_s]
	end

	def session_pay_link
		if @include
			"Enrolled!"
		else
			if @free_session
				link_to "Confirm", free_confirm_session_path(@session), class: 'btn'
			else
				link_to image_tag("paypal_button.png"), buy_now_session_path(@session)
			end
		end
	end

end
