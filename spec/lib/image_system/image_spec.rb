# encoding: utf-8
require 'spec_helper'
require 'uuidtools'

module ImageSystem
  describe "Image" do

    describe "#save" do

      it "saves an image that is new and has been uploaded successfully" do
        Photo.any_instance.stub(:new_record?) { true }
        p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")

        CDN::CommunicationSystem.stub(:upload) { true }
        CDN::CommunicationSystem.should_receive(:upload)
        p.should_receive(:super_saved_is_called)

        p.save
      end

      it "does not save an image that is new and has not been uploaded successfully" do
        Photo.any_instance.stub(:new_record?) { true }
        p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")

        CDN::CommunicationSystem.stub(:upload).and_raise(Exceptions::CdnUploadException.new("failed to upload"))
        CDN::CommunicationSystem.should_receive(:upload)
        p.should_not_receive(:super_saved_is_called)

        p.save
      end

      it "does not upload a new image that is not a new record abd does not have a new uuid" do

        Photo.any_instance.stub(:new_record?) { false }
        CDN::CommunicationSystem.stub(:upload) { true }
        Photo.any_instance.stub(:changed) { [] }

        p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")

        CDN::CommunicationSystem.should_not_receive(:upload)
        p.should_receive(:super_saved_is_called)

        p.save
      end

      it "uploads the image if its not a new record but has a new uuid" do

        Photo.any_instance.stub(:new_record?) { false }
        CDN::CommunicationSystem.stub(:upload) { true }
        Photo.any_instance.stub(:changed) { ["uuid"] }
        p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")

        CDN::CommunicationSystem.should_receive(:upload)
        p.should_receive(:super_saved_is_called)

        p.save

      end

    end

  end
end
