json.extract! user, :id, :first_name, :last_name, :phone, :username, :bio
json.extract! user, :created_at, :updated_at # TODO: hide if not admin
json.url user_url(user)
