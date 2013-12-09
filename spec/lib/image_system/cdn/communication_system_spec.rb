require 'spec_helper'
require 'uuidtools'
require 'cdnconnect_api'

module ImageSystem
  module CDN
    describe CDN::CommunicationSystem do

      before(:all) do

        file_args = { filename: 'rails.png',
                        content_type: 'image/png',
                        tempfile: File.new("#{Rails.root}/public/images/test_image.jpg")
                      }

        @file_path = ActionDispatch::Http::UploadedFile.new(file_args).path.to_s
        @uuid = "1"

        @cdn ||= CDNConnect::APIClient.new(app_host: CDN::ApiData::CDN_APP_HOST, api_key: CDN::ApiData::CDN_API_KEY)
        res = @cdn.upload(source_file_path: @file_path, destination_file_name: "#{@uuid}.jpg", queue_processing: false, destination_path: '/')
      end

      describe ".upload" do

        before(:all) do
          @uuid_to_upload = UUIDTools::UUID.random_create.to_s.gsub(/\-/, '')
        end

        it "receives a file and uploads it to cdn" do
          res = CDN::CommunicationSystem.upload(uuid: @uuid_to_upload, source_file_path: @file_path, queue_processing: false)
          expect(res).to eq(true)
        end

        it "returns an error message if uuid is nil" do
          expect { CDN::CommunicationSystem.upload(uuid: nil, source_file_path: @file_path, queue_processing: false) }.to raise_error(ArgumentError,"uuid is not set")
        end

        it "returns an error message if source_file_path is not set" do
          expect { CDN::CommunicationSystem.upload(uuid: @uuid_to_upload, source_file_path: nil, queue_processing: false) }.to raise_error(ArgumentError,"source file(s) required")
        end

        it "returns an error message for missing uuid if no arguments are set" do
          expect { CDN::CommunicationSystem.upload() }.to raise_error(ArgumentError, "uuid is not set")
        end

        it "returns an error message if the upload fails from cdn" do
          CDNConnect::APIClient.any_instance.stub(:upload) { [] }
          expect { CDN::CommunicationSystem.upload(uuid: @uuid_to_upload, source_file_path: @file_path, queue_processing: false)}.to raise_error(Exceptions::CdnUploadException, "failed to upload")
        end

      end

      describe ".download" do

        it "returns a string with the link to an image given it's uuid" do
          res = CDN::CommunicationSystem.download(uuid: @uuid)
          expect(res).to include("#{@uuid}.jpg")
        end

        it "returns an error message if uuid is nil" do
          expect { CDN::CommunicationSystem.download(uuid: nil) }.to raise_error(ArgumentError, "uuid is not set")
        end

        it "returns an error message if no arguments are given" do
          expect { CDN::CommunicationSystem.download() }.to raise_error(ArgumentError, "uuid is not set")
        end

        it "returns an image of a certain width if specified" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, width: 100)
          expect(res).to include("width=100")
        end

        it "returns an image of a certain height if specified" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, height: 50)
          expect(res).to include("height=50")
        end

        it "returns an image of a certain height and width if both are specified" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320)
          expect(res).to include("height=640")
          expect(res).to include("width=320")
        end

        it "returns an image with a certain quality if set" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320, quality: 10)
          expect(res).to include("quality=10")
        end

        it "returns an image with a quality of 95 if nothing is set" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, height: 640, width: 320)
          expect(res).to include("quality=95")
        end

        it "returns an image with the original aspect" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, aspect: :original)
          expect(res).to include("mode=max")
        end

         it "returns an image with another aspect if not the original one" do
          res = CDN::CommunicationSystem.download(uuid: @uuid, aspect: :square)
          expect(res).to include("mode=crop")
        end

      end

      describe ".rename" do

        before(:all) do
          @already_existing_uuid = 'rename_test_already_exists_exception.jpg'
          @cdn.upload(source_file_path: @file_path, destination_file_name: @already_existing_uuid, queue_processing: false, destination_path: '/')

          @old_uuid = "1"
          @new_uuid = "new_uuid"
        end

        after(:each) do
          @cdn.rename_object(path: "/#{@new_uuid}.jpg", new_name: "#{@old_uuid}.jpg")
        end

        it "returns true when renaming an object is successful" do
          res = CDN::CommunicationSystem.rename(old_uuid: @old_uuid, new_uuid: @new_uuid )
          expect(res).to eq(true)
        end

        it "returns an exception if an object is not found" do
          expect { CDN::CommunicationSystem.rename(old_uuid: "2", new_uuid: @new_uuid ) }.to raise_error(Exceptions::NotFoundException, "Does not exist any image with that uuid")
        end

        it "returns an exception if there is an image with the same uuid as new uuid" do
          expect { CDN::CommunicationSystem.rename(old_uuid: @old_uuid, new_uuid: @already_existing_uuid ) }.to raise_error(Exceptions::AlreadyExistsException, "There is an image with the same uuid as the new one")
        end

        it "returns an error if the old uuid is not provided" do
          expect { CDN::CommunicationSystem.rename( new_uuid: @already_existing_uuid ) }.to raise_error(ArgumentError,"old uuid is not set")
        end

        it "returns an error if the old uuid is not provided" do
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid ) }.to raise_error(ArgumentError,"new uuid is not set")
        end

        it "returns an error if the old uuid is the same as the new" do
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid, new_uuid: @old_uuid) }.to raise_error(ArgumentError,"old uuid is the same as the new")
        end

      end

    end
  end
end
