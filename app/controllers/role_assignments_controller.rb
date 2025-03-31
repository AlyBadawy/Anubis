class RoleAssignmentsController < ApplicationController
  # POST /roles/assign
  # POST /roles/assign.json
  def create
    @user = User.find(role_assignment_params[:user_id])
    @role_assignment = RoleAssignment.new(role_assignment_params)

    if @role_assignment.save
      render json: @user, status: :created, location: @user
    else
      render json: @role_assignment.errors, status: :unprocessable_entity
    end
  end

  # POST /roles/unassign
  # POST /roles/unassign.json
  def destroy
    @role_assignment = RoleAssignment.find_by(role_assignment_params)
    @role_assignment.destroy!
  end

  private

  def role_assignment_params
    params.expect(role_assignment: [:role_id, :user_id])
  end
end
