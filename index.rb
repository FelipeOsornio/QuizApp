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
  url_questions = 'https://4eni1m1l5g.execute-api.us-west-2.amazonaws.com/default/lambda_questions'

  response = Faraday.get(url_questions)

  if response.success?
    data = JSON.parse(response.body)
  end
end

post '/question' do
  URL_USERS = 'https://dw96994lzd.execute-api.us-west-2.amazonaws.com/default/users'

  USER_CREDENTIALS = {
      user: params['user'],
      pass: params['pass']
  }

  response = Faraday.post(URL_USERS) do |request|
    request.headers['Content-Type'] = 'application/json'
    request.body = USER_CREDENTIALS.to_json
  end

  if response.success?
    @questions = check_questions

    if @questions.empty?
      erb :upload, layout: :template
    else
      erb :table, layout: :template
    end
  else
    redirect '/login'
  end

end

def parse_json(csv_file)
  data_frame = Daru::DataFrame.from_csv(csv_file)
  data_frame
end

post '/upload-csv' do
  url_questions = 'https://4eni1m1l5g.execute-api.us-west-2.amazonaws.com/default/lambda_questions'

  datafile = params['csv-file']
  QUESTIONS = {
      questions: parse_json(datafile['tempfile'])
  }

  response = Faraday.post(url_questions) do |request|
    request.body = QUESTIONS.to_json
  end

  if response.success?
    @questions = JSON.parse(response.body)
    erb :table, layout: :template
  end

end

