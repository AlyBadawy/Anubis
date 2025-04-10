class RoleAssignmentsController < ApplicationController
  # POST /roles/assign
  # POST /roles/assign.json
  def create
    @user = User.find_by(id: role_assignment_params[:user_id]) # Ensure the user exists
    role = Role.find_by(id: role_assignment_params[:role_id]) # Ensure the role exists
    if @user.nil?
      render json: { error: "User not found" }, status: :unprocessable_entity
      return
    end
    if role.nil?
      render json: { error: "Role not found" }, status: :unprocessable_entity
      return
    end
    if @user.roles.exists?(role.id)
      render json: { error: "Role already assigned to user" }, status: :unprocessable_entity
      return
    end

    @role_assignment = RoleAssignment.new(role_assignment_params)
    if @role_assignment.save
      render :show, status: :created
    else
      # If the save fails, return the errors
      # This could be due to validation errors or other issues
      # For example, conflicting role assignments
      # or database constraints
      render json: @role_assignment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /roles/unassign
  # DELETE /roles/unassign.json
  def destroy
    @user = User.find_by(id: role_assignment_params[:user_id]) # Ensure the user exists
    role = Role.find_by(id: role_assignment_params[:role_id]) # Ensure the role exists
    if @user.nil?
      render json: { error: "User not found" }, status: :unprocessable_entity
      return
    end
    if role.nil?
      render json: { error: "Role not found" }, status: :unprocessable_entity
      return
    end
    @role_assignment = RoleAssignment.find_by(role_assignment_params)
    if @role_assignment
      @role_assignment.destroy!
      render :show, status: :ok
    else
      render json: { error: "Role is not assigned to user" }, status: :unprocessable_entity
    end
  end

  private

  def role_assignment_params
    params.expect(role_assignment: [:role_id, :user_id])
  end
end
