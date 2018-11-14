class PolicyManager::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/models.rake'
    load 'tasks/terms.rake'
  end
end
