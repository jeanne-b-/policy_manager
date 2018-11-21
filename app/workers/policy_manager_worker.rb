class PolicyManagerWorker
  include Sidekiq::Worker

  def perform gid, action, options = {}
    object = ::GlobalID::Locator.locate id
    object.send(action, *options)
  end
end

