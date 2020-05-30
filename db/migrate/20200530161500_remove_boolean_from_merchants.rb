class RemoveBooleanFromMerchants < ActiveRecord::Migration[5.1]
  def change
    remove_column :merchants, :boolean, :string
  end
end
