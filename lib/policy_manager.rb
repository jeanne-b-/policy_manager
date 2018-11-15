require "policy_manager/version"
require "generators/install" if defined?(Rails)
require "generators/serializer" if defined?(Rails)
require "policy_manager/railtie" if defined?(Rails)
require "policy_manager/engine"
require "policy_manager/registery"
require "policy_manager/config"

module PolicyManager
  # Your code goes here...
end
