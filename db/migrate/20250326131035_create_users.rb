class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :username, null: false
      t.string :bio

      t.timestamps
    end

    add_index :users, :email_address, unique: true
    add_index :users, :username, unique: true
  end
end
