class AddSubmitterToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :submitter, :string
  end
end
