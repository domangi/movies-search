require 'rails_helper'
RSpec.describe Movie, elasticsearch: true, :type => :model do
  it 'should be indexed' do
     expect(Movie.__elasticsearch__.index_exists?).to be_truthy
  end
end
