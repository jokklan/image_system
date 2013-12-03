# encoding: utf-8
require 'spec_helper'
require 'cdn/communication_system'
require 'image_system'
require 'support/schema'
require 'uuidtools'

describe "Photo" do

  describe "#save" do

    it "should only save if the image as been uploaded successfully" do
      p = Photo.new(uuid: UUIDTools::UUID.random_create.to_s.gsub(/\-/, ''), path: "#{Rails.root}/public/images/test_image.jpg")
      p.should be_new_record

      CDN::CommunicationSystem.stub(:upload) { true }
      CDN::CommunicationSystem.should_receive(:upload)

      p.save
      p.should_not be_new_record
    end
  end

end
