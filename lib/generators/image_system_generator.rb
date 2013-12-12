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
      migration_template 'add_cdn_fields_to_image.rb', "db/migrate/add_cdn_fields_to_#{class_name.pluralize}"
    end

  end
end
