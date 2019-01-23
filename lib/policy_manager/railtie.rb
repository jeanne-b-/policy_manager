class PolicyManager::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/models.rake'
    load 'tasks/terms.rake'
    load 'tasks/portability_requests.rake'
  end
end
