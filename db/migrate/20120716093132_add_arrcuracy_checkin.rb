class AddArrcuracyCheckin < ActiveRecord::Migration
  def change
    add_column :checkins, :accuracy, :decimal, :precision => 10, :scale => 2
  end

end
