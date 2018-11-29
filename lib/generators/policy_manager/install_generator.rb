require 'rails/generators'

module PolicyManager
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path('../../../migrations/', __FILE__)

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migrations
        migration_template "create_policy_manager_terms.rb", "db/migrate/create_policy_manager_terms.rb"
        sleep(1)
        migration_template "create_policy_manager_portability_requests.rb", "db/migrate/create_policy_manager_portability_requests.rb"
        sleep(1)
        migration_template "create_policy_manager_anonymize_requests.rb", "db/migrate/create_policy_manager_anonymize_requests.rb"
      end
    end
end
