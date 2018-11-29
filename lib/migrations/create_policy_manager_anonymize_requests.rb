class CreatePolicyManagerAnonymizeRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :policy_manager_anonymize_requests do |t|
      t.references :owner, polymorphic: true, index: {name: 'index_p_m_anonymize_requests_on_owner_type_and_owner_id'}
      t.string :attachement
      t.string :state
      t.string :requested_by
      t.datetime :expire_at
      t.timestamps
    end
  end
end
