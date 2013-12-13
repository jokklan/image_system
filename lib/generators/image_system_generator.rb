require 'rails/generators'
require 'rails/generators/active_record'

module Generators
  class ImageSystemGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    argument :class_name, :type => :string

    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      ActiveRecord::Generators::Base.next_migration_number(path)
    end

    desc "creates a migration to add uuid to the image table"

    def create_migrations
      if model_exists?
        path = migration_path("add_cdn_fields_to_#{class_name.pluralize}")
        migration_template 'add_cdn_fields_to_image.rb', path unless migration_exists?(path)
      else
        path = migration_path("create_#{class_name.pluralize}_with_cdn_fields")
        migration_template 'create_image_with_cdn_fields.rb', path unless migration_exists?(path)
      end
    end

    private

    def migration_path(name)
      @migration_path = File.join("db", "migrate", "#{name}.rb")
    end

    def model_path
      @model_path ||= File.join("app", "models", "#{class_name}.rb")
    end

    def model_exists?
      File.exists?(File.join(Rails.root, model_path))
    end

    def migration_exists?(path)
      File.exists?(File.join(Rails.root, path))
    end

  end
end
