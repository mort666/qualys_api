require 'test_helper'

class QualysTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Qualys::VERSION
  end

  def test_knowledge_base_request
    VCR.use_cassette('knowledge_base', :match_requests_on => [:method, :anonymized_uri]) do
      response = Qualys::KnowledgeBase.new('crtex-ta', 'U2GHQat2', :eu).get_qid('38602')

      assert_equal false, response.nil?
      assert_equal '38602', response.first.qid
      assert_equal '1', response.first.discovery.remote
    end
  end

  def test_authentication
    VCR.use_cassette('auth', :match_requests_on => [:method, :anonymized_uri]) do
      response = Qualys::Auth.new('USERNAME', 'PASSWORD', :eu).login

      assert_equal true, response
      assert_equal false, Qualys::Config.session_key.nil?
    end
  end

  def test_scan_api
    scan = Qualys::Scans.new('USERNAME', 'PASSWORD', :eu)
    VCR.use_cassette('scans', :match_requests_on => [:method, :anonymized_uri]) do

      response = scan.get_scans

      assert_equal false, response.nil?
      assert_equal Array, response.class

      assert_equal 'scan/1455012730.70775', response.first.ref
    end

    VCR.use_cassette('scan', :match_requests_on => [:method, :anonymized_uri]) do
      response = scan.get_scan('scan/1455012730.70775')

      assert_equal false, response.nil?

      assert_equal 82040, response.first.qid
    end
  end
end
