require 'csv'
require 'daru'
require './models/user'
require './models/question'

URL_USERS = 'https://e8wlv8kik5.execute-api.us-east-1.amazonaws.com/default/users'
URL_QUESTION = 'https://kdlcriiqz6.execute-api.us-east-1.amazonaws.com/default/questions'

def login
  @title_page = 'Log in'
  erb :login, layout: :session
end

def check_questions
  response = Request.get_request(URL_QUESTION)
  questions = []
  if response.success?
    data = Request.manage_response(response)
  end
  data.each do |question|
    questions << Question.new(question)
  end
  questions
end

def question
  @title_page = 'Question'
  user_obj = User.new(params['user'],params['pass'])

  response = Request.post_request(URL_USERS, {
      user: user_obj.user,
      pass: user_obj.pass
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
  begin
    response = Request.post_request(URL_QUESTION, {
        questions: parse_json(datafile['tempfile'])
    })
  rescue
    redirect '/upload-csv'
  end
  @questions = []
  if response.success?
    data = Request.manage_response(response)
    data.each do |question|
      @questions << Question.new(question)
    end
    erb :table, layout: :session
  end
end

def delete_questions
  response = Request.delete_request(URL_QUESTION)
  if response.success?
    redirect '/upload-csv'
  end
end
