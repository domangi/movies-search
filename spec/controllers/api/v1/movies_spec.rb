# spec/controllers/api/v1/movies_spec.rb
require 'rails_helper'
RSpec.describe Api::V1::MoviesController, type: :request do
  # Search for movie with text movie-title
  describe "GET /api/v1/movies?q=" do
    let(:title) { "movie-title"}
    let(:url) { "/api/v1/movies?q=#{title}"}

    it "calls Movie.search with correct parameters" do
      expect(Movie).to receive(:search).with(title)
      get url
    end

    it "returns the output of Movie.search" do
      allow(Movie).to receive(:search).and_return({})
      get url
      expect(response.body).to eq({}.to_json)
    end

    it 'returns a success status' do
      allow(Movie).to receive(:search).with(title)
      get url
      expect(response).to be_successful
    end
  end
end
