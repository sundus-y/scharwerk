require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  describe 'GET #tasks' do
    it 'returns stats' do
      Task.create(stage: :first_proof, status: :free)
      Task.create(stage: :first_proof, status: :active)
      get :tasks, stage: 'first_proof', format: :json
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['0']).to eq(1)
      expect(parsed_body['1']).to eq(1)
    end
  end
end