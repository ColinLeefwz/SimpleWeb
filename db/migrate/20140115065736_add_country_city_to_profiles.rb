class AddCountryCityToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :country, :string
    add_column :profiles, :city, :string
  end
end
