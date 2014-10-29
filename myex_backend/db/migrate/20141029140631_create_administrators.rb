class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :remember_token
      t.string :role
      t.string :token

      t.timestamps
    end
  end
end
