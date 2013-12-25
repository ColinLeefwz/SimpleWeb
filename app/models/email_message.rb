class EmailMessage < ActiveRecord::Base
  belongs_to :user

  after_initialize :set_default
  validates :to, presence: true

	private
	def set_default
		if self.invited_type == User::USER_TYPE[:expert]
      expert_email_content
    elsif self.invited_type  == User::USER_TYPE[:member]
      member_email_content
    end
	end

  def expert_email_content
		self.subject ||=  "Invitation to be an expert on Prodygia"
		self.message ||= <<CONTENT
    <p>I’m using a new site to read and display quality content on China and thought I’d share with you.</p>

    <p>It’s called Prodygia. What’s different with their model is that they start with experts, like you and me, and give us a toolkit to promote our knowledge on China and get paid. You can record on-demand video sessions and sell them to your network or run live sessions online. It’s quite unique and innovative in the market. They are carving out a niche for expertise on business, entrepreneurship, technology and culture as they relate to China.</p>

    <p>I encourage you to learn more about the platform and see how you can capitalize on it to build your online presence.</p>
    <p>Click below to sign up and enter your profile. It’s a first step. You can actually save time by signing up from your LinkedIn or Facebook accounts. Feel free to email specific questions to the Prodygia team on<a href="mailto:experts@prodygia.com"> experts@prodygia.com. </a>
    <p>Sincerely,</p>

    <p>#{self.from_name.titleize}</p>
CONTENT

    self.from_name = "Nicolas"
		self.from_address = "no-reply@prodygia.com"
		self.reply_to = "no-reply@prodygia.com"
  end

  def member_email_content
		self.subject ||=  "Invitation to be a member on Prodygia"
		self.message ||= <<CONTENT
    <p>I’m using a new site to read and display quality content on China and thought I’d share with you.</p>

    <p>It’s called Prodygia. What’s different with their model is that they start with experts, like you and me, and give us a toolkit to promote our knowledge on China and get paid. You can record on-demand video sessions and sell them to your network or run live sessions online. It’s quite unique and innovative in the market. They are carving out a niche for expertise on business, entrepreneurship, technology and culture as they relate to China.</p>

    <p>I encourage you to learn more about the platform and see how you can capitalize on it to build your online presence.</p>
    <p>Click below to sign up and enter your profile. It’s a first step. You can actually save time by signing up from your LinkedIn or Facebook accounts. Feel free to email specific questions to the Prodygia team on<a href="mailto:experts@prodygia.com"> experts@prodygia.com. </a>
    <p>Sincerely,</p>

    <p>#{self.from_name.titleize}</p>
CONTENT

    self.from_name = "Nicolas"
		self.from_address = "no-reply@prodygia.com"
		self.reply_to = "no-reply@prodygia.com"
  end
end