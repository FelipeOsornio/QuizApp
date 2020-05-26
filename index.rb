require 'csv'
require 'json'
require 'sinatra'
require 'faraday'
require 'daru'

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

get '/question' do
  erb :question, layout: :template
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
  @data_frame = Daru::DataFrame.from_csv(csv_file)
  @jsonObject = @data_frame.to_json()
end

post '/upload-csv' do
  url_questions = "https://idjxy904sl.execute-api.us-east-2.amazonaws.com/default/lambda_questions"
  
  datafile = params['csv-file']
  
  response = Faraday.post(url_questions) do |request|
    request.headers['Content-Type'] = 'application/json'
    request.body = parse_json(datafile['tempfile'])
  end
  
  puts response.body , response.status
  
  if response.success?
    puts "EL BIG SE LA COME" 
  end
  
end
