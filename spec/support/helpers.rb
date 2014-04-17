def helper_objects
  #experts
  let(:sameer) { create :expert, id: 1, email: 'sameer@test.com', password: '11111111', first_name: 'sameer', last_name: 'karim', user_name: "sameer-karim" } # , avatar: fixture_file_upload(('sameerkarim.png'), 'image/png')}
  let(:staff) { create :expert, id: 2, email: 'staff@prodygia.com', password: '11111111', first_name: 'staff', last_name: 'prodygia', user_name: "staff" } # , avatar: fixture_file_upload(('sameerkarim.png'), 'image/png')}
  let(:alex) {create :expert, id: 3, email: 'alex@test.com', password: '11111111', first_name: 'alex', last_name: 'lalo', user_name: "alex-lalo" } # , avatar: fixture_file_upload(('AD pic.jpg'), 'image/png') }

  # Members
  let(:peter) { create :member, id: 4, email: 'peter@test.com', password: '11111111', first_name: 'peter', last_name: 'zhao', user_name: "peter-zhao" } #, avatar: fixture_file_upload(('AD pic.jpg'), 'image/png')}
  let(:jevan) { create :member, id: 5, email: 'jevan@test.com', password: '11111111', first_name: 'jevan', last_name: 'wu', user_name: "jevan-wu"  } #, avatar: fixture_file_upload(('sameerkarim.png'), 'image/png')}
  let(:gecko) { create :member, id: 6, email: 'gecko@test.com', password: '11111111', first_name: 'gecko', last_name: 'fu', user_name: "gecko-fu" }
  let(:allen) { create :user, id: 7, email: 'allen@test.com', password: '11111111', first_name: 'allen', last_name: 'wang', user_name: "allen-wang" }

  #admins
  let(:admin) { create :admin_user, email: 'admin@example.com', password: 'password', first_name: 'admin', last_name: 'example', user_name: "admin"}

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
  let(:culture) { create :category, name: "culture" }

  #article
  let(:article) { create :article, title: 'Communicating With Chinese', expert: sameer, description: 'What cultural differences should I know when communicating with Chinese?', categories: [culture]}

  let(:announcement) { create :announcement, title: 'Just an Announcement', expert: alex,
                       description: 'Show you China road map', categories: [culture]}
  let(:announcement_sameer) { create :announcement, title: 'Just an Announcement', expert: sameer,
                       description: 'Show you China road map', categories: [culture]}
  #courses
  let(:first_course) { create :course, title: "first course", description: "course description", experts: [sameer], categories: [culture] }
  let(:course_staff) { create :course, title: "staff course", description: "course description", experts: [staff], categories: [culture] }

  #chapters
  let(:first_chapter) { create :chapter, title: "first chapter", description: "chapter description", course: first_course }

  #sections
  let(:first_section) { create :section, title: "first section", description: "section description", chapter: first_chapter }

  # video_interview
  let(:video_interview) { create :video_interview, title: "video interview", expert: sameer, description: "a video interview for sameer", categories: [culture] }

end
