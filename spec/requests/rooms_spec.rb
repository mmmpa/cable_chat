require 'rails_helper'

RSpec.describe 'Rooms', :type => :request do
  describe 'GET /rooms' do
    it  do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
