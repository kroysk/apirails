require "rails_helper"

RSpec.describe "Post endpoint", type: :request do

    describe "GET /post" do
        before {  get '/posts'}
        it "shoulf return OK" do
            payload = JSON.parse(response.body)
            expect(payload).to be_empty
            expect(response).to have_http_status(:ok)
        end
    end
    describe "with data in the DB" do
        let!(:posts){ create_list(:post, 10, published: true) }
        before {  get '/posts'}
        it "Should return all the published post" do
            payload = JSON.parse(response.body)
            expect(payload.size).to eq(posts.size)
            expect(response).to have_http_status(:ok)
        end
    end

    describe "GET /post/{id}" do
        let!(:post){ create(:post) }
        before {get "/posts/#{post.id}"}
        it "Should return a post" do
            payload = JSON.parse(response.body)
            expect(payload).not_to be_empty
            expect(payload["id"]).to eq(post.id)
            expect(response).to have_http_status(:ok)
        end
    end
    describe "POST /posts" do
        let!(:user){ create(:user) }
        it "Should return a post" do
            rq_payload = {
                post: {
                    title: 'titulo',
                    content: 'content',
                    published: 'false',
                    user_id: user.id
                }
            }
            post "/posts", params: rq_payload
            payload = JSON.parse(response.body)
            expect(payload).not_to be_empty
            expect(payload["id"]).not_to be_nil
            expect(response).to have_http_status(:created)
        end
    end

    describe "PUT /posts/{id}" do
        let!(:article){ create(:post) }
        it "Should return a post" do
            rq_payload = {
                post: {
                    title: 'titulo',
                    content: 'content',
                    published: 'false',
                }
            }
            put "/posts/#{article.id}", params: rq_payload
            payload = JSON.parse(response.body)
            expect(payload).not_to be_empty
            expect(payload["id"]).to eq(article.id)
            expect(response).to have_http_status(:ok)
        end
    end
end
