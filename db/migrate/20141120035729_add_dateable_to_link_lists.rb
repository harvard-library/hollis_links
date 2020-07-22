class AddDateableToLinkLists < ActiveRecord::Migration[4.2]
  def change
    add_column :link_lists, :dateable, :boolean, :default => true
  end
end
