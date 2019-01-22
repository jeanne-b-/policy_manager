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
      perform_job_at "async_#{caller.first.split(" ").last[1..-2]}", Time.zone.now, *args
    end

    def perform_job_at method, at, *args
      PolicyManagerWorker.perform_at at, self.to_global_id, method, method, args
    end
  end
end
