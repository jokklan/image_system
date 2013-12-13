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
        migration_template 'add_cdn_fields_to_image.rb', "db/migrate/add_cdn_fields_to_#{class_name.pluralize}"
      else
        migration_template 'create_image_with_cdn_fields.rb', "db/migrate/create_#{class_name.pluralize}_with_cdn_fields"
      end
    end

    private

    def model_path
      @model_path ||= File.join("app", "models", "#{class_name}.rb")
    end

    def model_exists?
      File.exists?(File.join(Rails.root, model_path))
    end

  end
end
