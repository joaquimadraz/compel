require 'pry'
require 'simplecov'
require 'codeclimate-test-reporter'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

require 'compel'

require 'rack/test'
require 'support/sinatra_app'

def app
  SinatraApp
end

include Rack::Test::Methods
