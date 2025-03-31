json.extract! role, :id, :role_name, :hide_from_profile
json.extract! role, :created_at, :updated_at # TODO: hide if not admin
json.url role_url(role, format: :json)
