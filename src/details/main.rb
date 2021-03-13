require 'sinatra'
require 'json'

require 'appdynamics/sinatra'
set(:appdynamics_config, file: "config/appdynamics.yml")

get '/health' do
    content_type :json
    {'status' => 'Details is healthy'}.to_json
end

get '/details/:id' do |id|
    content_type :json
    {
        'id' => Integer(id),
        'author': 'William Shakespeare',
        'year': 1595,
        'type' => 'paperback',
        'pages' => 200,
        'publisher' => 'PublisherA',
        'language' => 'English',
        'ISBN-10' => '1234567890',
        'ISBN-13' => '123-1234567890'
    }.to_json
end
