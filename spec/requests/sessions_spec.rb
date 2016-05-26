require 'rails_helper'

RSpec.describe 'Sessions', :type => :request do
  describe 'POST /sessions' do
    context 'post valid data' do
      it do
        post '/sessions', params: {session: {name: 'aaaa'}}
        expect(response).to have_http_status(200)
      end
    end

    context 'post invalid data' do
      it do
        post '/sessions', params: {session: {name: ''}}
        expect(response).to have_http_status(400)
      end
    end
  end
end
