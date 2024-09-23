module Deputies
  module ExpenseCalculable
    extend ActiveSupport::Concern

    included do
    end

    def calc_expenses_sum
      expenses.sum(:liquid_value)
    end

    def get_highest_expense
      expenses.maximum(:liquid_value)
    end
  end
end
