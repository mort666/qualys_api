module Qualys
  class Exception < RuntimeError; end
  class InvalidResponse < RuntimeError; end
  class InvalidLogin < RuntimeError; end

  class Base
    PRODUCTION_ENDPOINT = 'https://qualysapi.qualys.com/api/2.0/fo/'
    EU_PRODUCTION_ENDPOINT = 'https://qualysapi.qualys.eu/api/2.0/fo/'

    def initialize(username, password, server=:na)

      @server = server == :na ? PRODUCTION_ENDPOINT : EU_PRODUCTION_ENDPOINT

      @conn = Faraday.new(:url => @server) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.response :xml,  :content_type => /\bxml$/
        faraday.response :json, :content_type => /\bjson$/
      end

      @conn.basic_auth(username, password)
    end

    def get(url, params={})
      response = @conn.get do |req|
        req.url url
        req.params = params
        req.headers['X-Requested-With'] = "ruby qualys_api"
      end

      if response.status.eql?(401)
        raise Qualys::LoginRequired, "Invalid Login Credentials"
      elsif !response.status.eql?(200)
        raise Qualys::InvalidResponse, "Invalid Response Received"
      end

      return response
    end

    def post(url, params={})
      response = @conn.post do |req|
        req.url url
        req.body = params
        req.headers['X-Requested-With'] = "ruby qualys_api"
      end

      if response.status.eql?(401)
        raise Qualys::LoginRequired, "Invalid Login Credentials"
      elsif !response.status.eql?(200)
        raise Qualys::InvalidResponse, "Invalid Response Received"
      end

      return response
    end
  end

  module Config
    extend self

    attr_accessor :session_key
  end

  module Type
    class Base
      def initialize(hash)
        @raw_hash = downcase_hash(hash)
      end

      def method_missing(name, *args, &block)
        @raw_hash[name] if @raw_hash.key? name
        @raw_hash.each { |k,v| return v if k.to_s.to_sym == name }
        super.method_missing name
      end

      private
      
      def downcase_hash(value)
        case value
          when Array
            value.map { |v| downcase_hash(v) }
            # or `value.map(&method(:convert_hash_keys))`
          when Hash
            Hash[value.map { |k, v| [k.downcase, downcase_hash(v)] }]
          else
            value
         end
      end
    end
  end
end

class Hash
  def method_missing(name, *args, &block)
    self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end
