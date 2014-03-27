class AddDraftToLandingitem < ActiveRecord::Migration
  def change
    add_column :landingitems, :draft, :boolean, default: false
  end
end
