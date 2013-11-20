# encoding: utf-8
require 'spec_helper'
require 'cdn/communication_system'
require 'uuidtools'

describe CDN::CommunicationSystem do

  describe "#upload" do

    before(:all) do
      file_args = { filename: 'rails.png',
                    content_type: 'image/png',
                    tempfile: File.new("#{Rails.root}/public/images/test_image.jpg")
                  }
      @file_path = ActionDispatch::Http::UploadedFile.new(file_args).path.to_s
      @uuid = UUIDTools::UUID.random_create.to_s.gsub(/\-/, '')
    end

    it "should receive an file and upload it to cdn" do

      res = CDN::CommunicationSystem.upload(@uuid, source_file_path: @file_path, queue_processing: false)
      res.should eq(true)
    end

    it "should return an error message if uuid is nil" do

      expect { CDN::CommunicationSystem.upload(nil, source_file_path: @file_path, queue_processing: false) }.to raise_error(ArgumentError,"uuid is not set")
    end

    it "should return an error message if source_file_path is not set" do

      expect { CDN::CommunicationSystem.upload(@uuid, source_file_path: nil, queue_processing: false) }.to raise_error(ArgumentError,"source file(s) required")
    end
  end

end
