# quote_machine
Takes an image of a celebrity, finds a quote by them, then places the quote on the image.

## Installation
    bundle install
Note that [RMagick](http://rmagick.rubyforge.org/) and [Nokogiri](http://www.nokogiri.org/) are required, so you may need to follow the installation instructions associated with them, as they require compilation.

## Running
Before you run the application, you will need credentials for the following APIs:

https://www.microsoft.com/cognitive-services/en-us/computer-vision-api

http://www.alchemyapi.com/api/sentiment-analysis

Once you have keys for these APIs, copy creds_example.yml over to creds.yml and put the keys in that file. You can then run the app with:
    ruby main.rb
    
This will spin up a [Sinatra](http://www.sinatrarb.com/) server that you can hit on the following URL:

http://localhost:4567/

From there, just paste the URL of a celebrity image, select the quote type you want, and watch the magic happen!
