class AddLanguageToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :language, :string
  end
end
