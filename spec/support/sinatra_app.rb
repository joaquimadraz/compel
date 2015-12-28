require 'sinatra/base'
require 'compel'

class SinatraApp < Sinatra::Base

  set :show_exceptions, false
  set :raise_errors, true

  before do
    content_type :json
  end

  helpers do

    def compel(schema)
      params.merge! Compel.run!(params, Compel.hash.keys(schema))
    end

  end

  error Compel::InvalidObjectError do |exception|
    status 400
    { errors: exception.object[:errors] }.to_json
  end

  configure :development do
    set :show_exceptions, false
    set :raise_errors, true
  end

  post '/api/posts' do
    compel({
      post: Compel.hash.keys({
        title: Compel.string.required,
        body: Compel.string,
        published: Compel.boolean.default(false)
      }).required
    })

    params.to_json
  end

end
