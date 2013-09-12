json.array!(@propose_topics) do |propose_topic|
  json.extract! propose_topic, :Name, :Location, :Email, :Topic
  json.url propose_topic_url(propose_topic, format: :json)
end
