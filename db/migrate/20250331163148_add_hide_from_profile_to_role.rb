class AddHideFromProfileToRole < ActiveRecord::Migration[8.0]
  def change
    add_column :roles, :hide_from_profile, :boolean, default: false, null: false
  end
end
