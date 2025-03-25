json.extract! role, :id, :role_name
json.extract! role, :created_at, :updated_at # TODO: hide if not admin
json.url role_url(role, format: :json)
