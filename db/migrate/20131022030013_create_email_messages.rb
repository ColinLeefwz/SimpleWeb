class CreateEmailMessages < ActiveRecord::Migration
  def change
    create_table :email_messages do |t|
      t.string :subject
      t.string :to
      t.text :message
      t.boolean :copy_me
      t.string :from_name
      t.string :from_address
      t.string :reply_to
      t.references :expert, index: true

      t.timestamps
    end
  end
end
