require 'sinatra'
require './models/quiz'
require './models/player'
require './models/request'
require './models/question'

URL_GET_QUESTIONS = 'https://zbpbzqjeje.execute-api.us-east-1.amazonaws.com/default/get_questions'
URL_SCORES = 'https://ezq2yyaea4.execute-api.us-east-1.amazonaws.com/default/scores'

quiz = Quiz.new
player = Player.new

get '/' do
  @title_page = 'Pine app'
  erb :welcome, layout: :template
end

get '/start-quiz' do
  @title_page = 'Quiz'
  erb :start, layout: :template
end

post '/scores' do
  @title_page = 'Scores'
  player.score = params['grade'].to_i

  @username = player.username
  @score = player.score

  response = Request.post_request(URL_SCORES, {
      username: player.username,
      score: player.score
  })

  @scores = Request.manage_response(response)

  erb :scores, layout: :template
end

post '/quiz' do
  @title_page = 'Quiz app'

  number_questions = params['question_number'].to_i
  player.username = params['username']

  if number_questions < 1 or number_questions > 10
    redirect '/start-quiz'
  else
    response = Request.post_request(URL_GET_QUESTIONS, {
        number: number_questions
    })

    questions_response = Request.manage_response(response)

    questions_response.each do |question|
      quiz.question_answer << question['Answer']
      quiz.questions << Question.new(question)
    end

    @questions = quiz.questions

    erb :quiz, layout: :template
  end
end

post '/get-feedback' do
  @title_page = 'Feedback'

  answers = []
  params.each { |question, answer| quiz.user_answer << answer.to_i }

  player.score = (quiz.number_corrects * 100) / quiz.question_answer.length
  @feedback = player.score

  @questions = quiz.questions
  @user_answer = quiz.user_answer

  erb :feedback, layout: :template
end

