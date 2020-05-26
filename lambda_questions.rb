require 'json'
require 'aws-sdk-dynamodb'

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Questions'

class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
end

def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

def handle_bad_method(method)
  make_response(405, {message: "Method not supported: #{method}"})
end

def make_result_list(items)
  items.map do |item| {
      'Question' => item['Question'],
      'Options' => item['Options'],
      'Answer' => item['Answer'].to_i,
  }
  end
end

def sort_items(items)
  items.sort! {|a, b| a['Question'] <=> b['Question']}
  items.sort! {|a, b| a['Answer'] <=> b['Answer']}
end

def get_questions
  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  sort_items(items)
  make_result_list(items)
end

def handle_get
  make_response(HttpStatus::OK, get_questions)
end

def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('Question') and data.key?('Answer') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end

def store_question(body)
  data = parse_body(body)

  if data
    DYNAMODB.put_item({
                          table_name: TABLE_NAME,
                          item: data
                      })
    true
  else
    false
  end

end

def delete_question(body)
  data = parse_body(body)

  if data
    DYNAMODB.delete_item({
                             table_name: TABLE_NAME,
                             key: data
                         })
    true
  else
    false
  end

end

def handle_post
  make_response(HttpStatus::CREATED, {message: 'Resource created or updated'})
end

def handle_bad_request
  make_response(HttpStatus::BAD_REQUEST,
                {message: 'Bad request (invalid input)'})
end

def handle_delete
  make_response(HttpStatus::OK, {message: 'Item deleted'})
end

def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'GET'
    handle_get

  when 'POST'
    event['body']

  when 'DELETE'
    if delete_question(event['body'])
      handle_delete
    else
      handle_bad_request
    end

  end

end