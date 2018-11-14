require 'rails/generators'

module PolicyManager
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path('../../migrations/', __FILE__)

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def copy_migrations
        migration_template "create_terms.rb", "db/migrate/create_terms.rb"
      end
    end
  end
end
