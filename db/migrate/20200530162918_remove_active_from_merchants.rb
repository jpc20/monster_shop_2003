class RemoveActiveFromMerchants < ActiveRecord::Migration[5.1]
  def change
    remove_column :merchants, :active?, :string
  end
end
