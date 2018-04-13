require 'rails_helper'
RSpec.describe Movie, elasticsearch: true, :type => :model do
  it 'should be indexed' do
     expect(Movie.__elasticsearch__.index_exists?).to be_truthy
  end

  describe '#search' do
    before(:each) do
      Movie.create(
        title: "Roman Holiday",
        overview: "A 1953 American romantic comedy films ...",
        image_url: "wikimedia.com/Roman_holiday.jpg",
        vote_average: 4.0
      )
      Movie.__elasticsearch__.refresh_index!
    end
    it "should index title" do
      expect(Movie.search("Holiday").records.length).to eq(1)
    end
    it "should index overview" do
      expect(Movie.search("comedy").records.length).to eq(1)
    end
    it "should not index image_path" do
      expect(Movie.search("Roman_holiday.jpg").records.length).to eq(0)
    end
    it "should not index vote_average" do
      expect(Movie.search("4.0").records.length).to eq(0)
    end
    it "should apply stemming to title" do
      expect(Movie.search("Holidays").records.length).to eq(1)
    end
    it "should apply stemming to overview" do
      expect(Movie.search("film").records.length).to eq(1)
    end
  end
end
