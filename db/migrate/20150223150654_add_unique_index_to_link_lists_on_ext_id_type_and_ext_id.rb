class AddUniqueIndexToLinkListsOnExtIdTypeAndExtId < ActiveRecord::Migration
  def change
    add_index :link_lists, [:ext_id_type, :ext_id], :unique => true
  end
end
