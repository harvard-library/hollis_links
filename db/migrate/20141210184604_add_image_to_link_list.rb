class AddImageToLinkList < ActiveRecord::Migration[4.2]
  def change
    add_column :link_lists, :image, :string
  end
end
