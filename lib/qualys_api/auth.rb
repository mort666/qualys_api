module Qualys
  class Auth < Qualys::Base
    def initialize(username, password, server=:na)
      super(username, password, server)

      @username = username
      @password = password
    end
    
    def login
      params = { action: 'login', username: @username, password: @password }
      response = post('/api/2.0/fo/session/', params )

      Qualys::Config.session_key = response.headers['set-cookie']

      true
    end
  end
end
