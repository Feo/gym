class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :nickname
      t.string :name
      t.string :gender
      t.string :age
      t.string :profession
      t.string :province
      t.string :city
      t.string :district
      t.string :street
      t.string :phone
      t.string :email
      t.string :qq
      t.string :weixin
      t.string :password_digest
      t.string :remember_token
      t.text :sports
      t.boolean :have_coach, :default => true
      t.boolean :coach_id
      t.float :weixin

      t.timestamps
    end

    add_index :members, :email, unique: true
  end
end
