require 'sinatra'
require 'json'
require 'active_support' 
require 'active_support/core_ext'

require 'appdynamics/sinatra'
set(:bind, '0.0.0.0')
set(:port, 9080)

if ENV['SERVICE_VERSION'] === 'v1' then
    set(:appdynamics_config, file: "config/appdynamics-v1.yml")
else 
    set(:appdynamics_config, file: "config/appdynamics-v2.yml")
end

get '/health' do
    content_type :json
    {'status' => 'details is healthy', 'version' => ENV['SERVICE_VERSION']}.to_json
end

get '/details/:id' do |id|
    content_type :json
    get_book_details(id).to_json
end

def get_book_details(id)
    if ENV['ENABLE_EXTERNAL_BOOK_SERVICE'] === 'true' then
      # the ISBN of one of Comedy of Errors on the Amazon
      # that has Shakespeare as the single author
        isbn = '0486424618'
        return fetch_details_from_external_service(isbn, id)
    end

    return {
        'id' => id,
        'author': 'William Shakespeare',
        'year': 1595,
        'type' => 'paperback',
        'pages' => 200,
        'publisher' => 'PublisherA',
        'language' => 'English',
        'ISBN-10' => '1234567890',
        'ISBN-13' => '123-1234567890'
    }
end

def fetch_details_from_external_service(isbn, id)
    uri = URI.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:' + isbn)
    http = Net::HTTP.new(uri.host, ENV['DO_NOT_ENCRYPT'] === 'true' ? 80:443)
    http.read_timeout = 5 # seconds

    # DO_NOT_ENCRYPT is used to configure the details service to use either
    # HTTP (true) or HTTPS (false, default) when calling the external service to
    # retrieve the book information.
    #
    # Unless this environment variable is set to true, the app will use TLS (HTTPS)
    # to access external services.
    unless ENV['DO_NOT_ENCRYPT'] === 'true' then
      http.use_ssl = true
    end

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    json = JSON.parse(response.body)
    book = json['items'][0]['volumeInfo']

    language = book['language'] === 'en'? 'English' : 'unknown'
    type = book['printType'] === 'BOOK'? 'paperback' : 'unknown'
    isbn10 = get_isbn(book, 'ISBN_10')
    isbn13 = get_isbn(book, 'ISBN_13')

    return {
        'id' => id,
        'author': book['authors'][0],
        'year': book['publishedDate'],
        'type' => type,
        'pages' => book['pageCount'],
        'publisher' => book['publisher'],
        'language' => language,
        'ISBN-10' => isbn10,
        'ISBN-13' => isbn13
  }

end

def get_isbn(book, isbn_type)
  isbn_dentifiers = book['industryIdentifiers'].select do |identifier|
    identifier['type'] === isbn_type
  end

  return isbn_dentifiers[0]['identifier']
end
