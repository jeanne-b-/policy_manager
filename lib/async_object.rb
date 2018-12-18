module SidekiqHelpers
  module ClassicObject
    def perform_async init_args = [], args = []
      perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", Time.zone.now, init_args, args
    end

    def perform_async_at at, init_args = [], args = []
      perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", at, init_args, args
    end

    def perform_job_at method, at, init_args, args
      PolicyManagerWorker.perform_at at, [self.class.to_s, init_args], method, method, args
    end
  end

  module Base
    def perform_async *args
      perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", Time.zone.now, *args
    end

    def perform_async_at at, *args
      perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", at, *args
    end

    def perform_job method, *args
      perform_job_at method, Time.zone.now, *args
    end

    def perform_job_at method, at, *args
      PolicyManagerWorker.perform_at at, self.to_global_id, method, method, args
    end
  end

  module StaticBase
    def perform_async *args
      self.perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", Time.zone.now, *args
    end

    def perform_async_at at, *args
      self.perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", at, *args
    end

    def perform_job method, *args
      self.perform_job_at method, Time.zone.now, *args
    end

    def perform_job_at method, at, *args
      PolicyManagerWorker.perform_at at, self.to_s, method, method, args
    end
  end
end


class ActiveRecord::Base
  include SidekiqHelpers::Base
  extend SidekiqHelpers::StaticBase
end