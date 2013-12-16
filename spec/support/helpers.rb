def helper_objects
  # Members
  let(:peter) { create :member, email: 'peter@test.com', password: '11111111', first_name: 'peter', last_name: 'zhao', avatar: fixture_file_upload(('AD pic.jpg'), 'image/png')}
  let(:jevan) { create :member, email: 'jevan@test.com', password: '11111111', first_name: 'jevan', last_name: 'wu' , avatar: fixture_file_upload(('sameerkarim.png'), 'image/png')}
  let(:gecko) { create :member, email: 'gecko@test.com', password: '11111111', first_name: 'gecko', last_name: 'fu' }
  let(:allen) { create :user, email: 'allen@test.com', password: '11111111', first_name: 'allen', last_name: 'wang' }

  #experts
  let(:sameer) { create :expert, email: 'sameer@test.com', password: '11111111', first_name: 'sameer', last_name: 'karim', avatar: fixture_file_upload(('sameerkarim.png'), 'image/png')}
  let(:alex) {create :expert, email: 'alex@test.com', password: '11111111', first_name: 'alex', last_name: 'lalo', avatar: fixture_file_upload(('AD pic.jpg'), 'image/png') }

  #admins
  let(:admin) { create :admin_user, email: 'admin@example.com', password: 'password', first_name: 'admin', last_name: 'example'}

  #expert_profile
  let(:sameer_profile) {create :profile, title: "VP of stuff", company: "OC", location: "Shanghai", education: "UCLA", career: "Originate", user: sameer}
  let(:alex_profile) {create :profile, title: "Founder of Prodygia", company: "Prodygia", location: "Beijing", education: "UCLA", career: "Prodygia", user: alex}

  #member_profile
  let(:gecko_profile) {create :profile, title: "engineer", company: "OC", location: "Hangzhou", user: gecko}


  # static pages
  let(:page_about_us) { create :static_page, title: 'About us', content: 'about us page' }
  let(:page_faq) { create :static_page, title: 'Faq', content: 'faq page' }
  let(:page_terms) { create :static_page, title: 'Terms', content: 'terms page' }


  #categories
  let(:business) { create :category, name: "business" }
  let(:tech) { create :category, name: "tech" }

  #sessions
  let(:session_intro) { create :live_session, title: 'Intro Session to Lean Start-Up', expert: sameer,
                        description: 'How can lean start-up methods help me build a better business?',
                        status: 'Upcoming' }


  let(:session_communication) { create :article_session, title: 'Communicating With Chinese', expert: sameer,
                                description: 'What cultural differences should I know when communicating with Chinese?',
                                status: 'Prodygia Picks' }

  let(:session_find) { create :live_session, title: 'Find The Happier You', expert: alex,
                       description: 'How can I be happy despite the challenges of life?',
                       status: 'Scheduled' }

  let(:session_map) { create :live_session, title: 'China RoadMap', expert: alex,
                      description: 'Show you China road map',
                      status: 'Scheduled' }

  let(:session_draft_map) { create :live_session, title: 'live_session_draft', expert: alex, description: 'dddd', draft: true }
end


