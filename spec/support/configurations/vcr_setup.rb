require 'vcr'

VCR.configure do |c|
  #c.debug_logger = STDOUT
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'

  c.register_request_matcher :uri_ignoring_trailing_nonce do |request_1, request_2|
    uri1, uri2 = request_1.uri, request_2.uri
    regexp_trail_id = %r(upload-[0-9]{7}.*)
    if uri1.match(regexp_trail_id)
      r1_without_id = uri1.gsub(regexp_trail_id, "")
      r2_without_id = uri2.gsub(regexp_trail_id, "")
      uri1.match(regexp_trail_id) && uri2.match(regexp_trail_id) && r1_without_id == r2_without_id
    else
      uri1 == uri2
    end
  end
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
