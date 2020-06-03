require 'faraday'

class Request
  def self.get_request(route)
    Faraday.get(route)
  end

  def self.post_request(route, body)
    response = Faraday.post(route) do |request|
      request.body = body.to_json
    end

    response
  end

  def self.delete_request(route)
    Faraday.delete(route)
  end

  def self.manage_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      {status: response.status, message: 'failed'}
    end
  end
end
