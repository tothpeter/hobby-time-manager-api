module ControllerTest
  module AuthHelpers
    def authenticate_request user
      token = Tiddle.create_and_return_token(user, request)

      auth_headers = {
        'X-USER-TOKEN': token,
        'X-USER-EMAIL': user.email
      }

      request.headers.merge! auth_headers
    end
  end
end

module RequestTest
  module AuthHelpers
    def get_auth_headers user
      fake_request = OpenStruct.new
      token = Tiddle.create_and_return_token(user, fake_request)

      {
        'X-USER-TOKEN': token,
        'X-USER-EMAIL': user.email
      }
    end
  end
end
