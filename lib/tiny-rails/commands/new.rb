require 'fileutils'

module TinyRails
  module Commands
    class New < Thor::Group
      include Thor::Actions
      include Actions

      add_runtime_options!

      argument :app_path, :required => true

      class_option :addons, :type => :array,
        :aliases => '-a',
        :default => []

      # TODO: Move to a base command
      def self.source_root
        "#{File.expand_path('../../../../templates', __FILE__)}/"
      end

      def self.banner
        "tiny-rails new #{self.arguments.map(&:usage).join(' ')} [options]"
      end

      def self.templates
        @templates ||= %w(
          .gitignore
          Gemfile
          boot.rb
          tiny_rails_controller.rb
          index.html.erb
          server
          config.ru
        )
      end

      def create_root
        self.destination_root = File.expand_path(app_path)
        empty_directory '.'
        FileUtils.cd destination_root
      end

      def scaffold
        self.class.templates.each do |template|
          template(template)
        end
        chmod 'server', 0755
      end

      def apply_addon_scripts
        Add.start(options[:addons]) unless options[:addons].empty?
      end
    end
  end
end
