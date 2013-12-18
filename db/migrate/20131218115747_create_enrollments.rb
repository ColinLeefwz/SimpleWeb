class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :user
      t.references :enrollable, polymorphic: true
      t.timestamps
    end
  end
end
