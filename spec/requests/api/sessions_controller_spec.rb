describe "/sessions" do
  describe 'POST #create' do
    context 'when the credentials are valid' do
      it 'returns the expected json' do
        user = FactoryBot.create(:user)

        expect(Tiddle).to receive(:create_and_return_token).and_return('magic_token')

        request_arguments = {
          params: { user: { email: user.email, password: user.password } }
        }

        post '/sessions', request_arguments

        expect(json_response[:email]).to eq(user.email)
        expect(json_response[:token]).to eq('magic_token')
        expect(response.status).to eq(201)
      end
    end

    context 'when the credentials are invalid' do
      it 'returns 401' do
        request_arguments = {
          params: { user: { email: '', password: '' } }
        }

        post '/sessions', request_arguments

        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes the session token' do
      request_arguments = {
        headers: auth_headers
      }

      expect(current_user.authentication_tokens.count).to eq(1)

      delete '/sessions', request_arguments

      expect(current_user.authentication_tokens.count).to eq(0)

      expect(response.status).to eq(204)
    end
  end
end
