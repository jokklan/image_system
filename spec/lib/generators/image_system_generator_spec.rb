require 'spec_helper'
require "generators/image_system_generator"

module Generators

  describe ImageSystemGenerator do
    destination File.expand_path("../../tmp", __FILE__)

    before(:all) do
      prepare_destination
      run_generator %w(picture)
    end


    it "runs generator" do
      assert_migration "db/migrate/add_cdn_fields_to_pictures.rb", /def change/
      assert_migration "db/migrate/add_cdn_fields_to_pictures.rb", /change_table\(:pictures\)/
    end

    it "all files are properly deleted" do
      assert_migration "db/migrate/add_cdn_fields_to_pictures.rb"
      run_generator %w(picture), :behavior => :revoke
      assert_no_migration "db/migrate/add_cdn_fields_to_pictures.rb"
    end

  end
end
