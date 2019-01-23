namespace :policy_manager do
  namespace :portbility_requests do
    task delete_old_attachements: :environment do
      PolicyManager::PortabilityRequest.where.not(attachement: nil).where(expire_at: nil).update_all(expire_at: Time.zone.now)
      PolicyManager::PortabilityRequest.where('expire_at < ?', Time.zone.now).map &:delete_generated_json
    end
  end
end
