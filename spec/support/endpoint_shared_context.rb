module EndpointSharedContext
  extend RSpec::SharedContext

  before do
    host! 'api.timemanager.test'
  end

  let(:current_user) { FactoryBot.create(:user) }
  let(:auth_headers) { get_auth_headers(current_user) }
end
