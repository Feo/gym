class AddSubmitterToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :submitter, :string
  end
end
