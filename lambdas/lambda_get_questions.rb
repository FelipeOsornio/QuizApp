require 'json'
require 'aws-sdk-dynamodb'

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Questions'

class HttpStatus
  OK = 200
  CREATED = 201
  BAD_REQUEST = 400
end

def make_result_list(items)
  items.map do |item|
    {
        'Question' => item['Question'],
        'Options' => item['Options'].split(',').collect(&:strip),
        'Answer' => item['Answer'].to_i,
    }
  end
end

def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

def get_questions(number)
  items = (DYNAMODB.scan(table_name: TABLE_NAME).items).shuffle
  items = items.first(number)
  make_response(HttpStatus::OK, make_result_list(items))
end


def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'POST'
    get_questions(JSON.parse(event['body'])['number'].to_i)
  end

end
