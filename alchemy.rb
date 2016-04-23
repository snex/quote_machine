require 'httpi'
require 'yaml'
require 'json'

module Alchemy

  CREDS = YAML.load_file('creds.yml')['alchemy'].freeze

  def self.score_quote(quote)
    req = HTTPI::Request.new('http://gateway-a.watsonplatform.net/calls/text/TextGetTextSentiment')
    req.query = { 'apikey'     => CREDS['key'],
                  'text'       => quote,
                  'outputMode' => 'json' }
    req.headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
    req.gzip
    res = HTTPI.post(req)
    h = JSON.parse(res.body)
    if h['docSentiment'] && h['docSentiment']['score']
      return h['docSentiment']['score'].to_f
    else
      return nil
    end
  end

end
