# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Expert.delete_all
Session.delete_all

Alex = Expert.create(name: 'Alex',
										 image_url: 'AD pic.jpg',
										 company: 'Prodygia',
										 title: 'Co-Founder',
										 email: 'alex@oc.com',
										 authorized: true,
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


Nick = Expert.create(name: 'Nick',
										 image_url: 'guillaume profile pic.jpg',
										 company: 'Prodygia',
										 title: 'Founder',
										 email: 'nick@oc.com',
										 authorized: true,
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


gecko = Expert.create(name: 'Gecko',
											location: 'Hangzhou, China',
											email: 'gecko@oc.com',
											expertise: 'writting',
											authorized: false
										 )

jevan = Expert.create(name: 'jevan',
											location: 'Hangzhou, China',
											email: 'jevan@oc.com',
											expertise: 'cooking',
											authorized: false
										 )

Session.delete_all

=begin
Session.create(title: 'Intro Session to Lean Start-Up',
							 expert: Alex,
							 description: 'How can lean start-up methods help me build a better business?',
							 status: 'Upcoming',
							 image_url: 'china.jpg',
							 content_type: "live",
							 catalog: "culture")

Session.create(title: 'Communicating With Chinese',
							 expert: Alex,
							 description: 'What cultural differences should I know when communicating with Chinese?',
							 status: 'Prodygia Picks',
							 image_url: 'shutterstock.jpg',
							 content_type: "video",
							 catalog: "business")

Session.create(title: 'Find The Happier You',
							 expert: Nick,
							 description: 'How can I be happy despite the challenges of life?',
							 status: 'Scheduled',
							 image_url: 'test.jpg',
							 content_type: "text",
							 catalog: "entrepreneurship")

Session.create(title: 'Rails',
							 expert: Nick,
							 description: 'What cultural differences should I know when communicating with Chinese?',
							 status: 'Prodygia Picks',
							 image_url: 'shutterstock.jpg',
							 content_type: "video",
							 catalog: "business",
							 video_url: "movie.ogg")
Session.create(title: 'Intro Session to Lean Start-Up',
												expert: Alex,
													 description: 'How can lean start-up methods help me build a better business?',
															status: 'Upcoming',
																 image_url: 'china.jpg',
																		content_type: "live",
																			 catalog: "culture")

Session.create(title: 'Communicating With Chinese',
												expert: Alex,
													 description: 'What cultural differences should I know when communicating with Chinese?',
															status: 'Prodygia Picks',
																 image_url: 'shutterstock.jpg',
																		content_type: "video",
																			 catalog: "business")

Session.create(title: 'Find The Happier You',
												expert: Nick,
													 description: 'How can I be happy despite the challenges of life?',
															status: 'Scheduled',
																 image_url: 'social_media.jpg',
																		content_type: "text",
																			 catalog: "entrepreneurship")

Session.create(title: 'Rails',
												expert: Nick,
													 description: 'What cultural differences should I know when communicating with Chinese?',
															status: 'Prodygia Picks',
																 image_url: 'shutterstock.jpg',
																		content_type: "video",
																			 catalog: "business",
																					video_url: "movie.ogg")
Session.create(title: 'Intro Session to Lean Start-Up',
												expert: Alex,
													 description: 'How can lean start-up methods help me build a better business?',
															status: 'Upcoming',
																 image_url: 'china.jpg',
																		content_type: "live",
																			 catalog: "culture")

Session.create(title: 'Communicating With Chinese',
												expert: Alex,
													 description: 'What cultural differences should I know when communicating with Chinese?',
															status: 'Prodygia Picks',
																 image_url: 'shutterstock.jpg',
																		content_type: "video",
																			 catalog: "business")

Session.create(title: 'Find The Happier You',
												expert: Nick,
													 description: 'How can I be happy despite the challenges of life?',
															status: 'Scheduled',
																 image_url: 'social_media.jpg',
																		content_type: "text",
																			 catalog: "entrepreneurship")

Session.create(title: 'Rails',
												expert: Nick,
													 description: 'What cultural differences should I know when communicating with Chinese?',
															status: 'Prodygia Picks',
																 image_url: 'shutterstock.jpg',
																		content_type: "video",
																																													catalog: "business",
																					video_url: "movie.ogg")
=end
