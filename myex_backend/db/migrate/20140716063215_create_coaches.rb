class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.string :nickname
      t.string :name
      t.string :province
      t.string :city
      t.string :district
      t.string :phone
      t.string :email
      t.string :password_digest
      t.string :remember_token
      t.string :organization
      t.boolean :notification, :default => true
      t.boolean :open_question, :default => true
      t.boolean :one_to_one_teaching, :default => true
      t.boolean :one_to_many_teaching, :default => true

      t.timestamps
    end

    add_index :coaches, :email, unique: true
  end
end
