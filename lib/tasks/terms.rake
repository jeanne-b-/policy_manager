namespace :policy_manager do
  desc "Generate default terms"
  task terms: :environment do
    PolicyManager::Term.create(title: 'Privacy Policy', description: 'Privacy Policy')
  end
end
