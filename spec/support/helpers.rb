def helper_objects
  #experts
  let(:petter){ create :expert, name: 'petter', image_url: 'AD pic.jpg', company: 'Prodygia', title: 'Co-Founder'}
  let(:allen){create :expert, name: 'allen', image_url: 'guillaume profile pic.jpg', company: 'Prodygia', title: 'Founder'}  

  #sessions
  let(:first_session){create :session, title: 'Intro Session to Lean Start-Up', expert: petter,
			   description: 'How can lean start-up methods help me build a better business?',
			   status: 'Upcoming',
			   image_url: 'compass.jpg'}

  let(:second_session){create :session, title: 'Communicating With Chinese', expert: petter,
			   description: 'What cultural differences should I know when communicating with Chinese?',
			   status: 'Prodygia Picks',
			   image_url: 'hottie business.jpg'}

  let(:third_session){create :session, title: 'Find The Happier You', expert: allen,
	           description: 'How can I be happy despite the challenges of life?',
	           status: 'Scheduled',
	           image_url: 'couple on beach large.jpg'}
end	


