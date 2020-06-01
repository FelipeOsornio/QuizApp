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
      'username' => item['username'],
      'score' => item['score'].to_i
  }
  end
end

def get_scores
  items_db = DYNAMODB.scan(table_name: TABLE_NAME).items
  items_hash = make_result_list(items_db)
  items = items_hash.sort_by { |hash| hash['score'] }
  make_response(HttpStatus::OK, items.reverse().first(10))
end

def upload_score(score)
  DYNAMODB.put_item({table_name: TABLE_NAME,item: score})
end

def manage_score(body)
  begin
    data = JSON.parse(body)
    upload_score(data)
  rescue JSON::ParserError
    nil
  end
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
