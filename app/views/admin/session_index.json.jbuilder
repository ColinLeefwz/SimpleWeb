json.array!(@sessions) do |session|
  json.extract! session, :title, :expert_id_id, :created_date, :description
  json.url session_url(session, format: :json)
end
