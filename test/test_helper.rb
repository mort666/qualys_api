$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'qualys_api'

require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures"
  c.hook_into :webmock

  c.before_record do |i|
    i.request.headers.delete('Authorization')

    u = URI.parse(i.request.uri)
    i.request.uri.sub!(/:\/\/.*#{Regexp.escape(u.host)}/, "://#{u.host}")
  end

  c.register_request_matcher :anonymized_uri do |request_1, request_2|
    (URI(request_1.uri).port == URI(request_2.uri).port && URI(request_1.uri).path == URI(request_2.uri).path)
  end
end
