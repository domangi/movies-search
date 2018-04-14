# spec/controllers/api/v1/movies_spec.rb
require 'rails_helper'
RSpec.describe Api::V1::MoviesController, type: :request do
  # Search for movie with text movie-title
  describe "GET /api/v1/movies?q=" do
    let(:title) { "movie-title"}
    let(:url) { "/api/v1/movies?q=#{title}"}
    let(:movie) { Movie.new(title: title, overview: "lorem ipsum", image_url: "image-url", vote_average: 5) }

    it "calls Movie.search with correct parameters" do
      expect(Movie).to receive(:search).with(title)
      get url
    end

    it "returns the output of Movie.search in a movies element" do
      allow(Movie).to receive(:search).and_return([movie])
      get url
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(
        {
          "movies": [
            {
              "title": title,
              "overview": "lorem ipsum",
              "image_url": "image-url",
              "vote_average": "5"
            }
          ]
        }
      )
    end

    it 'returns a success status' do
      allow(Movie).to receive(:search).with(title)
      get url
      expect(response).to be_success
    end
  end
end
