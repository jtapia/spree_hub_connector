module SpreeHubConnector
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_hub_connector\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_hub_connector'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] ||
          ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
