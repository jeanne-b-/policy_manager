class PolicyManagerWorker
  include Sidekiq::Worker if defined?(Sidekiq)

  def perform gid, key, action, options = {}
    object = ::GlobalID::Locator.locate gid
    object.send(action, *options)
  end
end

