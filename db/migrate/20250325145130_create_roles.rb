class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :role_name

      t.timestamps
    end

    add_index :roles, :role_name, unique: true
  end
end
