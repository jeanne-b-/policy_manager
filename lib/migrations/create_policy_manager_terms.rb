class CreatePolicyManagerTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :policy_manager_terms do |t|
      t.string :state
      t.string :target
      t.string :kind
      t.timestamps
    end
  end
end
