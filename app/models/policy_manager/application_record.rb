module PolicyManager
  class ApplicationRecord < ActiveRecord::Base
    include GlobalID::Identification
    self.abstract_class = true

    def send_mail(mail)
      if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('5.0')
        PolicyManagerMailer.send(mail, self.id).deliver
      else
        PolicyManagerMailer.send(mail, self.id).deliver_now
      end
    end

    def send_admin_mail(mail)
      if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('5.0')
        PolicyManagerAdminMailer.send(mail, self.id).deliver
      else
        PolicyManagerAdminMailer.send(mail, self.id).deliver_now
      end
    end

    def perform_async *args
      if PolicyManager::Config.enable_sidekiq
        perform_job_at "async_#{caller_locations(1,1)[0].label}", Time.zone.now, *args
      else
        send("async_#{caller_locations(1,1)[0].label}", *(args.map { |arg| arg.is_a?(Hash) ? arg.with_indifferent_access : arg }))
      end
    end

    def perform_job_at method, at, *args
      PolicyManagerWorker.perform_at at, self.to_global_id, method, method, args
    end
  end
end
