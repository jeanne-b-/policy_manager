class CreatePolicyManagerTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :policy_manager_terms do |t|
      t.string :title
      t.text :description
      t.string :state
      t.timestamps
    end
  end
end
