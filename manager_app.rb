require 'csv'
require 'daru'
require 'sinatra'

URL_USERS = 'https://e8wlv8kik5.execute-api.us-east-1.amazonaws.com/default/users'
URL_QUESTION = 'https://kdlcriiqz6.execute-api.us-east-1.amazonaws.com/default/questions'

def login
  @title_page = 'Log in'
  erb :login, layout: :session
end

def check_questions
  response = Request.get_request(URL_QUESTION)

  if response.success?
    data = JSON.parse(response.body)
  end
end

def question
  @title_page = 'Questions'
  response = Request.post_request(URL_USERS, {
      user: params['user'],
      pass: params['pass']
  })

  if response.success?
    @questions = check_questions

    if @questions.empty?
      erb :upload, layout: :session
    else
      erb :table, layout: :session
    end
  else
    redirect '/login'
  end
end

def parse_json(csv_file)
  data_frame = Daru::DataFrame.from_csv(csv_file)
  data_frame
end

def view_upload_csv
  @title_page = 'Upload questions'
  erb :upload, layout: :session
end

def upload_csv
  datafile = params['csv-file']

  response = Request.post_request(URL_QUESTION, {
      questions: parse_json(datafile['tempfile'])
  })

  if response.success?
    @questions = JSON.parse(response.body)
    erb :table, layout: :session
  end
end

def delete_questions
  response = Request.delete_request(URL_QUESTION)
  redirect '/upload-csv'
end
