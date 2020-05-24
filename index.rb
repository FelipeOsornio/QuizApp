require 'csv'
require 'json'
require 'sinatra'
require 'faraday'

get '/' do
  @title_page = 'Pine app'
  erb :welcome, layout: :template
end

get '/login' do
  @title_page = 'Log in'
  erb :login, layout: :template
end

def check_questions
  url_questions = 'https://kdlcriiqz6.execute-api.us-east-1.amazonaws.com/default/questions'

  response = Faraday.get(url_questions)

  if response.success?
    data = JSON.parse(response.body)
  end
end

post '/question' do
  URL_USERS = 'https://e8wlv8kik5.execute-api.us-east-1.amazonaws.com/default/users'

  USER_CREDENTIALS = {
      user: params['user'],
      pass: params['pass']
  }

  response = Faraday.post(URL_USERS) do |request|
    request.headers['Content-Type'] = 'application/json'
    request.body = USER_CREDENTIALS.to_json
  end

  if response.success?
    @empty = check_questions.empty?
    erb :question, layout: :template
  else
    redirect '/login'
  end

end

def parse_json(csv_file)
  csv_table = CSV.parse(csv_file, headers: true)
  puts 'csv table:', csv_table
end

post '/upload-csv' do
  datafile = params['csv-file']
  parse_json(datafile['tempfile'])
end
