# encoding: utf-8
require 'spec_helper'
require 'cdn/communication_system'
require 'image_system'
require 'support/schema'
require 'uuidtools'
require 'exceptions/cdn_upload_exception'

describe "Photo" do

  describe "#save" do

    it "saves an image that is new and has been uploaded successfully" do
      p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")
      p.should be_new_record

      CDN::CommunicationSystem.stub(:upload) { true }
      CDN::CommunicationSystem.should_receive(:upload)

      p.save
      p.should_not be_new_record
    end

    it "does not save an image that is new and has not been uploaded successfully" do
      p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")
      p.should be_new_record

      CDN::CommunicationSystem.stub(:upload).and_raise(Exceptions::CdnUploadException.new("failed to upload"))
      CDN::CommunicationSystem.should_receive(:upload)

      p.save
      p.should be_new_record
    end

    it "does not upload a new image that is not a new record" do
      CDN::CommunicationSystem.stub(:upload) { true }
      p = Photo.create(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")
      p.should_not be_new_record

      CDN::CommunicationSystem.should_not_receive(:upload)
      p.save
    end

    it "uploads the image if its not a new record but has a new uuid" do
      CDN::CommunicationSystem.stub(:upload) { true }
      p = Photo.create(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")
      p.should_not be_new_record

      CDN::CommunicationSystem.should_receive(:upload)
      p.uuid = "new_uuid"
      p.save

    end

  end

end
