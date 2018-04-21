describe '/tasks' do
  context "when the current user is not an admin" do
    it "won't authorise current user and returns 403" do
      request_arguments = {
        headers: auth_headers,
        as: :json
      }

      post '/tasks', request_arguments

      expect(response).to have_http_status(403)

      current_user.manager!

      post '/tasks', request_arguments

      expect(response).to have_http_status(403)
    end
  end

  describe "POST #create" do
    before do
      current_user.admin!
    end

    context "when the current user creates a task for himself" do
      it "creates any task and returns it" do
        request_arguments = {
          headers: auth_headers,
          params: create_request_payload(current_user),
          as: :json
        }

        post '/tasks', request_arguments

        expect(json_response[:data][:attributes][:title]).to eq('Test title')
        expect(Task.count).to eq(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "when the current user creates a task for someone else" do
      it "creates any task and returns it" do
        other_user = FactoryBot.create :user

        request_arguments = {
          headers: auth_headers,
          params: create_request_payload(other_user),
          as: :json
        }

        post '/tasks', request_arguments

        expect(json_response[:data][:attributes][:title]).to eq('Test title')
        expect(Task.last.user_id).to eq(other_user.id)
        expect(Task.count).to eq(1)
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe "PATCH #update" do
    before do
      current_user.admin!
    end

    context "when the current user updates his own task" do
      it "updates the task and returns it" do
        task = FactoryBot.create :task, user: current_user
        request_payload  = patch_request_payload task, current_user
        updated_title = request_payload[:data][:attributes][:title] += 'Update1'

        request_arguments = {
          headers: auth_headers,
          params: request_payload,
          as: :json
        }

        patch "/tasks/#{task.id}", request_arguments

        expect(response.code).to eq('200')
        expect(json_response[:data][:attributes][:title]).to eq(updated_title)
      end
    end

    context "when the current user updates a task of someone else" do
      it "updates the user and returns it" do
        other_user = FactoryBot.create :user
        task = FactoryBot.create :task, user: other_user
        request_payload  = patch_request_payload task, other_user
        updated_title = request_payload[:data][:attributes][:title] += 'Update1'

        request_arguments = {
          headers: auth_headers,
          params: request_payload,
          as: :json
        }

        patch "/tasks/#{task.id}", request_arguments

        expect(response.code).to eq('200')
        expect(json_response[:data][:attributes][:title]).to eq(updated_title)
      end
    end
  end

  def patch_request_payload task, owner
    {
      data: {
        id: task.id,
        attributes: {
          title: task.title,
          description: task.description,
          date: "#{task.date}T00:00:00.000Z",
          duration: task.duration
        },
        relationships: {
          user: {
            data: {
              type: 'users',
              id: owner.id
            }
          }
        },

        type: 'tasks'
      }
    }
  end

  def create_request_payload user
    {
      data:{
        attributes: {
          title: "Test title",
          description: "Test desc",
          date: "2018-03-05T13:39:48.758Z",
          duration: 1
        },
        relationships: {
          user: {
            data: {
              type: 'users',
              id: user.id
            }
          }
        },
        type: 'tasks'
      }
    }
  end
end
