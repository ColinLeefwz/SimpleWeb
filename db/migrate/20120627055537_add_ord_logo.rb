class AddOrdLogo < ActiveRecord::Migration
  def change
    add_column :user_logos, :ord, :decimal, :precision => 10, :scale => 2
  end
end
