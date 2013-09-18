class Expert < User
	has_one :profile, class_name: 'ExpertProfile'

end
