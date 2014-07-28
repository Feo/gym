class AddAttributesToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :street, :string
    add_column :coaches, :qq, :string
    add_column :coaches, :weixin, :string
    add_column :coaches, :grade, :float
  end
end
