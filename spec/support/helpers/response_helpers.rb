module ResponseHelpers
  def json_response
    @json_response ||= parse_json(response.body)
  end
end
