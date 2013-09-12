class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :name
      t.string :title
      t.string :company
      t.string :location
      t.text :expertise
      t.text :favorite_quote
      t.text :career
      t.text :education
      t.text :web_site
      t.text :article_reports
      t.text :speeches
      t.text :additional
      t.text :testimonials

      t.timestamps
    end
  end
end
