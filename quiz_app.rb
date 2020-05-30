require 'sinatra'
require './models/request'
require './models/quiz'

URL_GET_QUESTIONS = 'https://zbpbzqjeje.execute-api.us-east-1.amazonaws.com/default/get_questions'
quiz = Quiz.new

get '/' do
  @title_page = 'Pine app'
  erb :welcome, layout: :template
end

get '/start-quiz' do
  @title_page = 'Quiz'
  erb :input, layout: :template
end

get '/get-feedback' do
  @title_page = 'Feedback'
  @feedback = quiz.number_corrects
  erb :feedback, layout: :template
end

get '/scores' do

end

post '/scores' do

end

post '/quiz' do
  @title_page = 'Quiz app'
  number_questions = params['question_number'].to_i

  if number_questions < 1 or number_questions > 10
    redirect '/start-quiz'
  else
    response = Request.post_request(URL_GET_QUESTIONS, {
        number: number_questions
    })

    @questions = Request.manage_response(response)

    question_answer = []
    @questions.each do |question|
      question_answer << question['Answer']
    end

    quiz.question_answer = question_answer

    erb :quiz, layout: :template
  end
end

post '/get-feedback' do
  user_answer = JSON.parse(params['user_answer'])
  quiz.user_answer = user_answer
end

