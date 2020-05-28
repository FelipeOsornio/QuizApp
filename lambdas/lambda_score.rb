require 'json'
require 'aws-sdk-dynamodb'

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Scores'

class HttpStatus
  OK = 200
  CREATED = 201
  FORBIDDEN = 403
end

def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

def make_result_list(items)
  items.map do |item| {
      'user' => item['user'],
      'pass' => item['pass']
  }
  end
end

def get_scores
  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  items.first(10)
  make_response(HttpStatus::OK, make_result_list(items))
end

def upload_score(score)
  DYNAMODB.put_item({table_name: TABLE_NAME,item: score})
end

def manage_score(body)
  upload_score(JSON.parse(body)['score'])
  get_scores
end

def lambda_handler(event:, context:)
    method = event['httpMethod']

    case method
    when 'GET'
      get_scores
    when 'POST'
      manage_score(event['body'])
    end
end
