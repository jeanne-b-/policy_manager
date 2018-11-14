module PolicyManager
  class Config
    def self.setup
      yield self
      self
    end
  end
end
