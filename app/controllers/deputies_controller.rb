class DeputiesController < ApplicationController
    def index
      @deputies = Deputy.all
      render json: @deputies
    end

    def show
      @deputy = Deputy.find(params[:id])
      render json: @deputy.to_json(include: :expenses)
    end

    def return_expenses_sum
      @deputy = Deputy.find(params[:id])
      render json: {
      "name": @deputy.name,
      "cpf": @deputy.cpf,
      "party": @deputy.party,
      "expenses_sum": @deputy.calc_expenses_sum
    }
    end

    def return_highest_expense
      @deputy = Deputy.find(params[:id])
      render json: {
      "name": @deputy.name,
      "cpf": @deputy.cpf,
      "party": @deputy.party,
      "highest_expense": @deputy.get_highest_expense
      }
    end

    def list_expenses
      @deputy = Deputy.find(params[:id])
      expenses = @deputy.expenses.select(:liquid_value, :supplier, :issue_date, :invoice_url, :id)
      render json: {
      "name": @deputy.name,
      "cpf": @deputy.cpf,
      "party": @deputy.party,
      "expenses": expenses
      }
    end
end
