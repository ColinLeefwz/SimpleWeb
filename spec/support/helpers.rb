def helper_objects
	# Members
	let(:peter) { create :member, email: 'peter@test.com', password: '11111111', first_name: 'peter', last_name: 'zhao' }
	let(:jevan) { create :member, email: 'jevan@test.com', password: '11111111', first_name: 'jevan', last_name: 'wu' }
	let(:gecko) { create :member, email: 'gecko@test.com', password: '11111111', first_name: 'gecko', last_name: 'fu' }

  #experts
  let(:sameer) { create :expert, email: 'sameer@test.com', password: '11111111', first_name: 'sameer', last_name: 'karim'}
  let(:alex) {create :expert, email: 'alex@test.com', password: '11111111', first_name: 'alex', last_name: 'lalo' }

  #sessions
  let(:session_intro) { create :announcement, title: 'Intro Session to Lean Start-Up', expert: sameer,
			   description: 'How can lean start-up methods help me build a better business?',
			   status: 'Upcoming' }


  let(:session_communication) { create :article_session, title: 'Communicating With Chinese', expert: sameer,
			   description: 'What cultural differences should I know when communicating with Chinese?',
			   status: 'Prodygia Picks' }

  let(:session_find) { create :live_session, title: 'Find The Happier You', expert: alex,
	           description: 'How can I be happy despite the challenges of life?',
	           status: 'Scheduled' }

  let(:session_map) { create :video_session, title: 'China RoadMap', expert: alex,
	           description: 'Show you China road map',
	           status: 'Scheduled' }
end


