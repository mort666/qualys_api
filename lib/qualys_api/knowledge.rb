module Qualys
  class KnowledgeBase < Qualys::Base

    def get_qid(qids)
      raise ArgumentError if qids.nil?

      uri = '/api/2.0/fo/knowledge_base/vuln/'
      params = {
        action: 'list',
        details: 'All',
        ids: qids
      }

      response = get(uri, params)

      unless response.body['KNOWLEDGE_BASE_VULN_LIST_OUTPUT']['RESPONSE'].has_key? 'VULN_LIST'
        return []
      end

      kb = response.body['KNOWLEDGE_BASE_VULN_LIST_OUTPUT']['RESPONSE']['VULN_LIST']['VULN']

      if kb.class == Hash
        return [Qualys::Knowledge.new(kb)]
      elsif kb.class == Array
        kb.map! do |qid|
          Qualys::Knowledge.new(qid)
        end
      else
        return []
      end
    end
  end
end
