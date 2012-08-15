class AddCodeMcities < ActiveRecord::Migration
  def change
    add_column :mcities, :code, :string
  end

end

