class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :ip_address, null: false
      t.string :user_agent, null: false
      t.string :refresh_token, null: false
      t.integer :refresh_count, default: 0
      t.datetime :last_refreshed_at
      t.datetime :refresh_token_expires_at
      t.boolean :revoked, default: false, null: false

      t.timestamps
    end
  end
end
