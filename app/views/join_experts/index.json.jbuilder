json.array!(@join_experts) do |join_expert|
  json.extract! join_expert, :Name, :Location, :Email, :Expertise
  json.url join_expert_url(join_expert, format: :json)
end
