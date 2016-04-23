require 'sinatra'
require 'sinatra/flash'
require 'httpi'
require 'json'

require_relative 'microsoft'
require_relative 'brainy_quote'
require_relative 'alchemy'
require_relative 'paint'

enable :sessions

get '/' do
  erb :index
end

post '/quote' do
  res = JSON.parse(Microsoft::analyze_image(params['image']))
  celebs = []
  if res['categories'].nil?
    flash[:error] = res.inspect
    redirect '/' and return
  end
  res['categories'].each do |category|
    if category.has_key?('detail') && category['detail'].has_key?('celebrities')
      category['detail']['celebrities'].each do |celeb|
        celebs << celeb
      end
    end
  end
  if celebs.empty?
    flash[:error] = 'No celebrities detected.'
    redirect '/' and return
  end
  celeb = celebs.sort_by { |c| c['confidence'] }.last
  quotes = BrainyQuote::brainy_quotes(celeb['name'])
  if quotes.empty?
    flash[:error] = "No quotes found for #{celeb['name']}."
    redirect '/' and return
  end

  quote_to_use = ''

  if params['quote_type'] != 'random'
    quotes_scores = []
    quotes.each do |quote|
      score = Alchemy::score_quote(quote)
      quotes_scores << [quote, score]
    end

    quotes_scores.reject! { |qs| qs[1].nil? }
    quotes_scores.sort_by! { |qs| qs[1] }

    if params['quote_type'] == 'best'
      quote_to_use = quotes_scores.last[0]
    else
      quote_to_use = quotes_scores.first[0]
    end
  else
    quote_to_use = quotes.sample
  end

  Paint::paint_image(params['image'], quote_to_use + "\n--#{celeb['name']}", celeb['faceRectangle'])

  erb :quote
end
