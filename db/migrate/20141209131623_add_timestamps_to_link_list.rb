class AddTimestampsToLinkList < ActiveRecord::Migration[4.2]
  def change
    add_column :link_lists, :created_at, :datetime
    add_column :link_lists, :updated_at, :datetime
  end
end
