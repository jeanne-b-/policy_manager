class PolicyManagerWorker
  include Sidekiq::Worker if defined?(Sidekiq)
  if PolicyManager::Config.sidekiq_queue
    sidekiq_options queue: PolicyManager::Config.sidekiq_queue
  end

  def perform gid, key, action, options = {}
    object = ::GlobalID::Locator.locate gid
    object.send(action, *options)
  end
end

