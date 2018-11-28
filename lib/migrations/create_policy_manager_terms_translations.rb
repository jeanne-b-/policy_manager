class CreatePolicyManagerTermsTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :policy_manager_terms_translations do |t|
      t.integer :term_id, index: true
      t.string :title
      t.text :content
      t.text :content_html
      t.string :locale
      t.timestamps
    end
  end
end
