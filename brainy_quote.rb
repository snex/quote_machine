require 'httpi'
require 'json'
require 'cgi'
require 'nokogiri'

module BrainyQuote

  def self.brainy_quotes(name)
    req = HTTPI::Request.new
    req.url = "https://www.brainyquote.com/search_results.html?q=#{CGI.escape(name)}"
    res = HTTPI.get(req)
    doc = Nokogiri::HTML(res.body)
    #doc.xpath("//span[@class='bqQuoteLink']").map(&:inner_text)
    # only grab 1 quote for testing to avoid API rate limit
    [doc.xpath("//span[@class='bqQuoteLink']")[0].inner_text]
  end

end
