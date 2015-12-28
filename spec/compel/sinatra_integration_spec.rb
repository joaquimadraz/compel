describe Compel do

  context 'Sinatra Integration' do

    it 'should return 400 for missing params' do
      post('/api/posts') do |response|
        response_json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(response_json['errors']['post']).to \
          include('is required')
      end
    end

    it 'should return 400 for missing title' do
      params = {
        post: {
          body: 'Body',
          published: 0
        }
      }

      post('/api/posts', params) do |response|
        response_json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(response_json['errors']['post']['title']).to \
          include('is required')
      end
    end

    it 'should return 400 for invalid boolean' do
      params = {
        post: {
          title: 'Title',
          published: 'falss'
        }
      }

      post('/api/posts', params) do |response|
        response_json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(response_json['errors']['post']['published']).to \
          include("'falss' is not a valid Boolean")
      end
    end

    it 'should return 200' do
      params = {
        post: {
          title: 'Title',
          body: 'Body',
          published: false
        }
      }

      post('/api/posts', params) do |response|
        response_json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_json['post']).to \
          eq({
            'title' => 'Title',
            'body' => 'Body',
            'published' => false
          })
      end
    end

  end

end
