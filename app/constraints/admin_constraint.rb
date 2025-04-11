class AdminConstraint
  def matches?(request)
    authenticated = AuthenticationHelper.authenticate!(request)
    return false unless authenticated

    Current.user.roles.any? do |role|
      role.role_name == "Admin" || role.role_name == "Super Admin"
    end
  end
end
