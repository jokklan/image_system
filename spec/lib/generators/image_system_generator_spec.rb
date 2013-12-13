require 'spec_helper'
require "generators/image_system_generator"
require "generator_spec"

module Generators

  describe ImageSystemGenerator do
    destination File.expand_path("../../tmp", __FILE__)

    before(:all) do
      @class_name = "picture"
      prepare_destination
    end

    context "When the model exists" do
      before(:each) do
        @args = File.join(Rails.root, File.join("app", "models", "picture.rb"))
        allow(File).to receive(:exists?).with(@args).and_return(true) { File.unstub(:exists?) }
        run_generator %w(picture)
      end

      it "runs generator and correct files are created" do
        assert_migration "db/migrate/add_cdn_fields_to_pictures.rb", /def change/
        assert_migration "db/migrate/add_cdn_fields_to_pictures.rb", /change_table\(:pictures\)/
      end
    end

    context "When the model does not exist" do

      before(:all) do
        run_generator %w(picture)
      end

      it "runs generator and correct files are created" do
        assert_migration "db/migrate/create_pictures_with_cdn_fields.rb", /def change/
        assert_migration "db/migrate/create_pictures_with_cdn_fields.rb", /create_table\(:pictures\)/
      end
    end

  end
end
