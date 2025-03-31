class CreateRoleAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :role_assignments, id: :uuid do |t|
      t.references :role, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
