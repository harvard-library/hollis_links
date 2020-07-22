class AddFieldsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :affiliation, :string
    add_column :users, :username, :string
  end
end
