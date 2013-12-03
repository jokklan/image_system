# encoding: utf-8
require 'spec_helper'
require 'cdn/communication_system'
require 'uuidtools'

describe CDN::CommunicationSystem do

  describe ".upload" do

    before(:all) do
      file_args = { filename: 'rails.png',
                    content_type: 'image/png',
                    tempfile: File.new("#{Rails.root}/public/images/test_image.jpg")
                  }
      @file_path = ActionDispatch::Http::UploadedFile.new(file_args).path.to_s
      @uuid = UUIDTools::UUID.random_create.to_s.gsub(/\-/, '')
    end

    it "receives a file and uploads it to cdn" do
      res = CDN::CommunicationSystem.upload(uuid: @uuid, source_file_path: @file_path, queue_processing: false)
      res.should eq(true)
    end

    it "returns an error message if uuid is nil" do
      expect { CDN::CommunicationSystem.upload(uuid: nil, source_file_path: @file_path, queue_processing: false) }.to raise_error(ArgumentError,"uuid is not set")
    end

    it "returns an error message if source_file_path is not set" do
      expect { CDN::CommunicationSystem.upload(uuid: @uuid, source_file_path: nil, queue_processing: false) }.to raise_error(ArgumentError,"source file(s) required")
    end

    it "returns an error message for missing uuid if no arguments are set" do
      expect { CDN::CommunicationSystem.upload() }.to raise_error(ArgumentError, "uuid is not set")
    end
  end

  describe ".download" do

    before(:all) do
      @uuid = "1"
    end

    it "returns a string with the link to an image given it's uuid" do
      res = CDN::CommunicationSystem.download(uuid: @uuid)
      res.should include("#{@uuid}.jpg")
    end

    it "returns an error message if uuid is nil" do
      expect { CDN::CommunicationSystem.download(uuid: nil) }.to raise_error(ArgumentError, "uuid is not set")
    end

    it "returns an error message if no arguments are given" do
      expect { CDN::CommunicationSystem.download() }.to raise_error(ArgumentError, "uuid is not set")
    end

    it "returns an image of a certain width if specified" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, width: 100)
      res.should include("width=100")
    end

    it "returns an image of a certain height if specified" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, height: 50)
      res.should include("height=50")
    end

    it "returns an image of a certain height and width if both are specified" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320)
      res.should include("height=640")
      res.should include("width=320")
    end

    it "returns an image with a certain quality if set" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320, quality: 10)
      res.should include("quality=10")
    end

    it "returns an image with a quality of 95 if nothing is set" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320)
      res.should include("quality=95")
    end

    it "returns an image with the original aspect" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, aspect: :original)
      res.should include("mode=max")
    end

     it "returns an image with another aspect if not the original one" do
      res = CDN::CommunicationSystem.download(uuid: @uuid, aspect: :square)
      res.should include("mode=crop")
    end

  end

end
