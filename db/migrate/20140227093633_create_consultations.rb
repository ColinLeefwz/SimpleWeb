class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.references :requester, index: true
      t.references :consultant, index: true
      t.string :description
      t.string :status
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
