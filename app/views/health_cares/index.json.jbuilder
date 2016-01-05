json.array!(@health_cares) do |health_care|
  json.extract! health_care, :id, :affiliate, :regime, :eps, :ips, :register, :card, :poll_date, :score, :inhabilites, :inh_description
  json.url health_care_url(health_care, format: :json)
end
