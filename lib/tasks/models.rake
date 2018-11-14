namespace :policy_manager do
  desc "load up all tables and check if they are registered"
  task models: :environment do
    registery = PolicyManager::Registery.new
    tables = ActiveRecord::Base.connection.tables
    tables.sort.each do |table_name|
      if registery.registered? table_name
        puts table_name.green and next
      else
        puts table_name.red
      end
      model = table_name.capitalize.singularize.camelize.constantize rescue nil
      if model
        puts model.inspect
      else
        puts "could not find associated model."
      end
    end
  end
end
