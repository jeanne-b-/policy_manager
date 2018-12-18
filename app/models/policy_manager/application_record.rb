module PolicyManager
  class ApplicationRecord < ActiveRecord::Base
    include GlobalID::Identification
    self.abstract_class = true

    # def perform_async *args
    #   perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", Time.zone.now, *args
    # end

    # def perform_job_at method, at, *args
    #   PolicyManagerWorker.perform_at at, self.to_global_id, method, method, args
    # end
  end
end
