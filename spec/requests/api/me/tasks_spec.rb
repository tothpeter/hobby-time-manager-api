describe '/me/tasks' do

  describe "#validate_date_filter" do
    context "when the start date filter is missing" do
      it "returns a 422" do
        request_arguments = {
          headers: auth_headers,
          params: { start_date: 1 }
        }

        get '/me/tasks', request_arguments

        expect(json_response[:errors][0][:title]).to include('missing')
        expect(response.code).to eq('422')
      end
    end

    context "when the end date filter is missing" do
      it "returns a 422" do
        request_arguments = {
          headers: auth_headers,
          params: { end_date: 1 }
        }

        get '/me/tasks', request_arguments

        expect(json_response[:errors][0][:title]).to include('missing')
        expect(response.code).to eq('422')
      end
    end

    context "when the time gap between start and end date is bigger than 3 months" do
      it "returns a 422" do
        request_arguments = {
          headers: auth_headers,
          params: {
            start_date: '2000-12-01',
            end_date: '2001-03-04'
          }
        }

        get '/me/tasks', request_arguments

        expect(json_response[:errors][0][:title]).to include('months')
        expect(response.code).to eq('422')
      end
    end

    context "when the params contain something funny" do
      it "returns a 422" do
        request_arguments = {
          headers: auth_headers,
          params: {
            start_date: 'hack',
            end_date: 'malicious content'
          }
        }

        get '/me/tasks', request_arguments

        expect(json_response[:errors][0][:title]).to include('invalid')
        expect(response.code).to eq('422')
      end
    end

    context "when the params are good" do
      it "returns a 422" do
        request_arguments = {
          headers: auth_headers,
          params: {
            start_date: '2000-01-01',
            end_date: '2000-04-01'
          }
        }

        get '/me/tasks', request_arguments

        expect(response.code).to eq('200')
      end
    end
  end

  describe "GET #index" do
    it "returns the tasks of the current user only" do
      FactoryBot.create :task
      task = FactoryBot.create :task, user: current_user

      request_arguments = {
        headers: auth_headers,
        params: {
          start_date: task.date,
          end_date: task.date
        }
      }

      get '/me/tasks', request_arguments

      expect(json_response[:data][0][:id].to_i).to eq(task.id)
      expect(json_response[:data].length).to eq(1)
    end

    it "returns a 401 when the user is not authenticated" do
      get '/me/tasks'

      expect(response.code).to eq('401')
    end
  end

  describe "POST #create" do
    context "when the current user creates a task for himsel" do
      it "creates a new task and returns it" do
        request_arguments = {
          headers: auth_headers,
          params: create_request_payload(current_user),
          as: :json
        }

        post '/me/tasks', request_arguments

        expect(json_response[:data][:attributes][:title]).to eq('Test title')
        expect(Task.count).to eq(1)
        expect(Task.last.user_id).to eq(current_user.id)
        expect(response).to have_http_status(:created)
      end
    end

    context "when the current user creates a task for someone else" do
      it "creates a new task for himsel anyway and returns it" do
        other_user = FactoryBot.create :user

        request_arguments = {
          headers: auth_headers,
          params: create_request_payload(other_user),
          as: :json
        }

        post '/me/tasks', request_arguments

        expect(json_response[:data][:attributes][:title]).to eq('Test title')
        expect(Task.count).to eq(1)
        expect(Task.last.user_id).to eq(current_user.id)
        expect(response).to have_http_status(:created)
      end
    end
  end


  describe "PATCH #update" do
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

        patch "/me/tasks/#{task.id}", request_arguments

        expect(response.code).to eq('200')
        expect(json_response[:data][:attributes][:title]).to eq(updated_title)
      end
    end

    context "when the current user assigns his task to someone else" do
      it "won't assign the task to someone else" do
        other_user = FactoryBot.create :user
        task = FactoryBot.create :task, user: current_user
        request_payload = patch_request_payload task, other_user
        updated_title = request_payload[:data][:attributes][:title] += 'Update1'

        request_arguments = {
          headers: auth_headers,
          params: request_payload,
          as: :json
        }

        patch "/me/tasks/#{task.id}", request_arguments

        expect(response.code).to eq('200')
        expect(json_response[:data][:attributes][:title]).to eq(updated_title)
        expect(Task.last.user_id).to eq(current_user.id)
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
