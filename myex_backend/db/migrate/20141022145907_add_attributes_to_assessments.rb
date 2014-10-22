class AddAttributesToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :photo_url_1, :string
    add_column :assessments, :photo_url_2, :string
  end
end
