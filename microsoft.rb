require 'httpi'
require 'yaml'
require 'json'

module Microsoft

  CREDS = YAML.load_file('creds.yml')['microsoft'].freeze

  def self.analyze_image(url)
    req = HTTPI::Request.new
    req.url = 'https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=Categories&details=Celebrities'
    req.body = { 'url' => url }.to_json
    req.headers = { 'Content-Type'              => 'application/json',
                    'Ocp-Apim-Subscription-Key' => CREDS['key'] }
    res = HTTPI.post(req)
    res.body
  end

end
