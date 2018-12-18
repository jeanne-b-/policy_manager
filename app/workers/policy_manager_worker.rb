class PolicyManagerWorker
  include Sidekiq::Worker if defined?(Sidekiq)

  def perform gid, key, action, options = {}
    object = ::GlobalID::Locator.locate id
    object.send(action, *options)
  end
end

