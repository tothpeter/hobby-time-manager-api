# frozen_string_literal: true

module JSONHelpers
  def parse_json(data)
    JSON.parse(data, symbolize_names: true)
  end
end
