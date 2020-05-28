require 'json'
require 'aws-sdk-dynamodb'

DYNAMODB = Aws::DynamoDB::Client.new
TABLE_NAME = 'Users'

class HttpStatus
  OK = 200
  CREATED = 201
  FORBIDDEN = 403
end

def parse_body(body)
  if body
    begin
      data = JSON.parse(body)
      data.key?('user') and data.key?('pass') ? data : nil
    rescue JSON::ParserError
      nil
    end
  else
    nil
  end
end

def make_result_list(items)
  items.map do |item| {
      'User' => item['User'],
      'Password' => item['Password']
  }
  end
end

def compare_user(body)
  data = parse_body(body)

  items = DYNAMODB.scan(table_name: TABLE_NAME).items
  users = make_result_list(items)


  if data
    res = make_response('', '')

    items.each{ |user|
      if user['User'] == data['user'] and user['Password'] == data['pass']
        res = make_response(HttpStatus::OK, {message: 'allowed'})
      elsif user['User'] != data['user']
        res = make_response(HttpStatus::FORBIDDEN, {message: 'user error'})
      else
        res = make_response(HttpStatus::FORBIDDEN, {message: 'pass error'})
      end
    }

    res
  end

end

def make_response(status, body)
  {
      statusCode: status,
      body: JSON.generate(body)
  }
end

def lambda_handler(event:, context:)
  method = event['httpMethod']

  case method
  when 'POST'
    compare_user(event['body'])

  end

end
