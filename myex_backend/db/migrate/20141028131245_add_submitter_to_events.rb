class AddSubmitterToEvents < ActiveRecord::Migration
  def change
    add_column :events, :submitter, :string
  end
end
