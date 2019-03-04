module SpreeAvataxOfficial
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :run_migrations, type: :boolean, default: true
      class_option :run_seeds, type: :boolean, default: true

      def self.source_paths
        paths = superclass.source_paths
        paths << File.expand_path('templates', __dir__)
        paths.flatten
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_avatax_official'
      end

      def run_migrations
        if options[:run_migrations]
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def run_seeds
        if options[:run_seeds]
          run 'bundle exec rake spree_avatax_official:load_seeds'
        else
          puts 'Skipping seeds, you can run them through bundle exec rake spree_avatax_official:load_seeds'
        end
      end

      def copy_initializer
        template 'config/initializers/spree_avatax_official.rb', 'config/initializers/spree_avatax_official.rb'
      end
    end
  end
end
