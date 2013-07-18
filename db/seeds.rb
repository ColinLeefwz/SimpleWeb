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
			  title: 'Co-Founder'
			  )


allen = Expert.create(name: 'allen',
			  image_url: 'guillaume profile pic.jpg',
			  company: 'Prodygia',
			  title: 'Founder')



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
			   image_url: 'hottie business.jpg')

Session.create(title: 'Find The Happier You',
	           expert: allen,
	           description: 'How can I be happy despite the challenges of life?',
	           status: 'Scheduled',
	           image_url: 'couple on beach large.jpg')



