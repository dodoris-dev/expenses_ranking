require 'rails_helper'
require 'rspec'

RSpec.describe DeputiesController, type: :request do
  let!(:deputy) { create(:deputy) } # Usa FactoryBot para criar um deputy
  let!(:expenses) { create_list(:expense, 3, deputy: deputy) } # Cria algumas despesas associadas ao deputy

  describe 'GET #index' do
    it 'returns a success response with all deputies' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(Deputy.count)
    end
  end

  describe 'GET #show' do
    it 'returns the deputy with associated expenses' do
      get :show, params: { id: deputy.id }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(deputy.id)
      expect(json_response['expenses'].size).to eq(deputy.expenses.count)
    end
  end

  describe 'GET #return_expenses_sum' do
    before do
      allow(deputy).to receive(:calc_expenses_sum).and_return(5000.00)
    end

    it 'returns the deputy with the total sum of expenses' do
      get :return_expenses_sum, params: { id: deputy.id }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(deputy.name)
      expect(json_response['cpf']).to eq(deputy.cpf)
      expect(json_response['party']).to eq(deputy.party)
      expect(json_response['expenses_sum']).to eq(5000.00)
    end
  end

  describe 'GET #return_highest_expense' do
    let!(:highest_expense) { expenses.first }

    before do
      allow(deputy).to receive(:get_highest_expense).and_return(highest_expense)
    end

    it 'returns the deputy with the highest expense' do
      get :return_highest_expense, params: { id: deputy.id }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(deputy.name)
      expect(json_response['cpf']).to eq(deputy.cpf)
      expect(json_response['party']).to eq(deputy.party)
      expect(json_response['highest_expense']['id']).to eq(highest_expense.id)
    end
  end

  describe 'GET #list_expenses' do
    it 'returns the deputy with a list of selected expenses attributes' do
      get :list_expenses, params: { id: deputy.id }
      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq(deputy.name)
      expect(json_response['cpf']).to eq(deputy.cpf)
      expect(json_response['party']).to eq(deputy.party)

      expenses_json = json_response['expenses']
      expect(expenses_json.size).to eq(deputy.expenses.count)

      expense_keys = [ 'liquid_value', 'supplier', 'issue_date', 'invoice_url', 'id' ]
      expenses_json.each do |expense|
        expect(expense.keys).to match_array(expense_keys)
      end
    end
  end
end
