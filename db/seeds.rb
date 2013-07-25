# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Expert.delete_all
Session.delete_all

peter = Expert.create(name: 'peter',
			  image_url: 'AD pic.jpg',
			  company: 'Prodygia',
			  title: 'Co-Founder',
			  location: "Shanghai, China",
			  expertise: "Doing Business in China",
			  favorite_quote: "\"Whether you think you can or you think you can\'t-- you\'re right.\"
- Henry Ford",
              career: "Prodygia, Co-Founder (current) \n HROne, Board Member (current) \n",
              education: "Kellogg Business School, Northwestern University, MBA \n Politecnico di Milano, Management Engineering Degree \n",
              web_site: "www.jljgroup.com \n www.hroneonline.com \n",
              article_reports: 'Published many industry and strategy reports about the Chinese market. ',
              speeches: 'Frequent speaker at seminars, conferences, workshops, organized by government and trade organizations, industry associations, chambers of commerce. In China, the United States, Italy, New Zealand, Malaysia. ',
              additional: 'Interests and hobbies include internet technologies, chess, long-distance running, scuba diving, cooking, NLP, and meditation.',
              testimonials: "\"Thank you for your precious contribution to the project; we highly appreciate your professionalism.\" \n
              Ferdinando Gueli, Deputy Trade Commissioner, Italian Trade Commission, Shanghai, China"
			  )


allen = Expert.create(name: 'allen',
			  #image_url: 'guillaume profile pic.jpg',
			  company: 'Prodygia',
			  title: 'Founder',
			  location: "Shanghai, China",
			  expertise: "Doing Business in China",
			  favorite_quote: "\"Whether you think you can or you think you can\'t-- you\'re right.\"
- Henry Ford",
              career: "Prodygia, Co-Founder (current) \n HROne, Board Member (current) \n",
              education: "Kellogg Business School, Northwestern University, MBA \n Politecnico di Milano, Management Engineering Degree \n",
              web_site: "www.jljgroup.com \n www.hroneonline.com \n",
              article_reports: 'Published many industry and strategy reports about the Chinese market. ',
              speeches: 'Frequent speaker at seminars, conferences, workshops, organized by government and trade organizations, industry associations, chambers of commerce. In China, the United States, Italy, New Zealand, Malaysia. ',
              additional: 'Interests and hobbies include internet technologies, chess, long-distance running, scuba diving, cooking, NLP, and meditation.',
              testimonials: "\"Thank you for your precious contribution to the project; we highly appreciate your professionalism.\" \n
              Ferdinando Gueli, Deputy Trade Commissioner, Italian Trade Commission, Shanghai, China"
			  )



# Session.create(title: 'First Session', 
# 	           expert: peter,
# 			   description: 'just a test',
# 			   status: 'Prodygia Picks')
			  
# Session.create(title: 'Second Session', 
# 	           expert: allen,
# 			   description: 'just a test2',
# 			   status: 'Prodygia Picks')

Session.create(title: 'Intro Session to Lean Start-Up', 
	           expert: peter,
			   description: 'How can lean start-up methods help me build a better business?',
			   status: 'Upcoming',
			   image_url: 'compass.jpg')
			  
Session.create(title: 'Communicating With Chinese', 
	           expert: peter,
			   description: 'What cultural differences should I know when communicating with Chinese?',
			   status: 'Prodygia Picks',
			   image_url: 'hottie business.jpg' )

Session.create(title: 'Find The Happier You',
	           expert: allen,
	           description: 'How can I be happy despite the challenges of life?',
	           status: 'Scheduled',
	           image_url: 'couple on beach large.jpg')



