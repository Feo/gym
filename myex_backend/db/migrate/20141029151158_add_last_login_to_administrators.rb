class AddLastLoginToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :last_login, :datetime
  end
end
