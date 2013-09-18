class CreateExpertProfiles < ActiveRecord::Migration
  def change
    create_table :expert_profiles do |t|
      t.string :title
      t.string :company
			t.string :location
      t.text :expertise
      t.text :favorite_quote
      t.text :career
      t.text :education
      t.text :web_site
      t.text :article_reports
      t.text :additional
      t.text :testimonials
			t.references :expert, index: true

      t.timestamps
    end
  end
end
