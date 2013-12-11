require 'spec_helper'
require 'uuidtools'
require 'cdnconnect_api'

module ImageSystem
  module CDN
    describe CDN::CommunicationSystem do

      before(:all) do
        VCR.use_cassette('image_system/cdn/communication_system_upload/before_all', :match_requests_on => [:method, :uri_ignoring_trailing_nonce]) do
          file_args = { filename: 'rails.png',
                          content_type: 'image/png',
                          tempfile: File.new("#{Rails.root}/public/images/test_image.jpg")
                        }

          @file_path = ActionDispatch::Http::UploadedFile.new(file_args).path.to_s
          @uuid = "1"

          @cdn ||= CDNConnect::APIClient.new( app_host: CDN::ApiData::CDN_APP_HOST,
                                              api_key: CDN::ApiData::CDN_API_KEY)

          res = @cdn.upload( source_file_path: @file_path,
                             destination_file_name: "#{@uuid}.jpg",
                             queue_processing: false,
                             destination_path: '/')

          @already_existing_uuid = 'rename_test_already_exists_exception'
          @cdn.upload( source_file_path: @file_path,
                       destination_file_name: "#{@already_existing_uuid}.jpg",
                       queue_processing: false,
                       destination_path: '/')
        end
      end

      after(:all) do
        VCR.use_cassette('image_system/cdn/communication_system_upload/after_all', :match_requests_on => [:method, :uri_ignoring_trailing_nonce]) do
          @cdn.delete(uuid: @uuid)
          @cdn.delete(uuid: @already_existing_uuid)
        end
      end

      describe ".upload" do

        before(:all) do
          @uuid_to_upload = UUIDTools::UUID.random_create.to_s.gsub(/\-/, '')
        end

        it "receives a file and uploads it to cdn", :vcr, match_requests_on: [:method, :uri_ignoring_trailing_nonce] do
          res = CDN::CommunicationSystem.upload( uuid: @uuid_to_upload,
                                                   source_file_path: @file_path)
          expect(res).to eq(true)
        end

        it "returns an error message if uuid is nil" do
          expect { CDN::CommunicationSystem.upload( uuid: nil,
                                                    source_file_path: @file_path) }.to raise_error(ArgumentError, "uuid is not set")
        end

        it "returns an error message if source_file_path is not set" do
          expect { CDN::CommunicationSystem.upload( uuid: @uuid_to_upload,
                                                    source_file_path: nil) }.to raise_error(ArgumentError, "source file(s) required")
        end

        it "returns an error message for missing uuid if no arguments are set" do
          expect { CDN::CommunicationSystem.upload }.to raise_error(ArgumentError, "uuid is not set")
        end

        it "returns an error message if the upload fails from cdn" do
          CDNConnect::APIClient.any_instance.stub(:upload) { Response.new(:status => 503) }
          expect { CDN::CommunicationSystem.upload( uuid: @uuid_to_upload,
                                                    source_file_path: @file_path) }.to raise_error(Exceptions::CdnResponseException, "http_response was nil")
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
          VCR.use_cassette('image_system/cdn/communication_system_rename/before_all', :match_requests_on => [:method, :uri_ignoring_trailing_nonce]) do
            @old_uuid = "1"
            @new_uuid = "new_uuid"
          end
        end

        after(:each) do
          VCR.use_cassette('image_system/cdn/communication_system_rename/after_all', :match_requests_on => [:method, :uri_ignoring_trailing_nonce]) do
            @cdn.rename_object(path: "/#{@new_uuid}.jpg", new_name: "#{@old_uuid}.jpg")
          end
        end

        it "returns true when renaming an object is successful", :vcr do
          res = CDN::CommunicationSystem.rename(old_uuid: @old_uuid, new_uuid: @new_uuid)
          expect(res).to eq(true)
        end

        it "returns an exception if an object is not found", :vcr do
          expect { CDN::CommunicationSystem.rename( old_uuid: "2",
                                                    new_uuid: @new_uuid) }.to raise_error(Exceptions::NotFoundException, "Does not exist any image with that uuid")
        end

        it "returns an exception if there is an image with the same uuid as new uuid", :vcr do
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid,
                                                    new_uuid: @already_existing_uuid) }.to raise_error(Exceptions::AlreadyExistsException, "There is an image with the same uuid as the new one")
        end

        it "returns an error if the old uuid is not provided" do
          expect { CDN::CommunicationSystem.rename( new_uuid: @already_existing_uuid) }.to raise_error(ArgumentError,"old uuid is not set")
        end

        it "returns an error if the new uuid is not provided" do
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid ) }.to raise_error(ArgumentError,"new uuid is not set")
        end

        it "returns an error if the old uuid is the same as the new" do
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid,
                                                    new_uuid: @old_uuid) }.to raise_error( ArgumentError,"old uuid is the same as the new")
        end

        it "returns an error if the renaming fails" do
          CDNConnect::APIClient.any_instance.stub(:rename_object) { Response.new }
          expect { CDN::CommunicationSystem.rename( old_uuid: @old_uuid,
                                                    new_uuid: @new_uuid) }.to raise_error( Exceptions::CdnUnknownException, "cdn communication system failed" )
        end

      end

      describe ".delete" do

        it "deletes the picture and returns true if the given uuid exists", :vcr, match_requests_on: [:method, :uri_ignoring_trailing_nonce] do
          res = CDN::CommunicationSystem.delete(uuid: @already_existing_uuid)
          expect(res).to eq(true)

          # Make sure the file does not disappear for other tests
          @cdn.upload( source_file_path: @file_path,
                       destination_file_name: "#{@already_existing_uuid}.jpg",
                       queue_processing: false,
                       destination_path: '/')
        end

        it "does not delete if it does exist and returns an error", :vcr do
          expect { CDN::CommunicationSystem.delete(uuid: "non_existing_uuid") }.to raise_error(Exceptions::NotFoundException, "Does not exist any image with that uuid")
        end

        it "does not delete if no uuid is given and returns an error" do
          expect { CDN::CommunicationSystem.delete() }.to raise_error(ArgumentError,"uuid is not set")
        end

        it "returns an error if the deleting operation fails" do
          CDNConnect::APIClient.any_instance.stub(:delete_object) { Response.new }
          expect { CDN::CommunicationSystem.delete(uuid: "non_existing_uuid") }.to raise_error( Exceptions::CdnUnknownException, "cdn communication system failed" )
        end

      end

    end
  end
end
