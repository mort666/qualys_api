module Qualys
  class Scans < Qualys::Base
    def get_scans
      uri = '/api/2.0/fo/scan/'
      params = {
        action: 'list',
      }

      response = get(uri, params)

      unless response.body['SCAN_LIST_OUTPUT']['RESPONSE'].has_key? 'SCAN_LIST'
        return []
      end

      scans = response.body['SCAN_LIST_OUTPUT']['RESPONSE']['SCAN_LIST']['SCAN']

      if scans.class == Hash
        return [Qualys::Scan.new(scans)]
      elsif scans.class == Array
        scans.map! do |scan|
          Qualys::Scan.new(scan)
        end
      else
        return []
      end
    end

    def get_scan(scan_ref)
      raise ArgumentError if scan_ref.nil?

      uri = '/api/2.0/fo/scan/'
      params = {
        action: 'fetch',
        mode: 'extended',
        output_format: 'json',
        scan_ref: scan_ref
      }

      response = get(uri, params)

      issues = JSON.parse(response.body)

      if issues.class == Hash
        return [Qualys::Issue.new(issues)]
      elsif issues.class == Array
        issues.map! do |issue|
          Qualys::Issue.new(issue)
        end
      else
        return []
      end
    end
  end
end
