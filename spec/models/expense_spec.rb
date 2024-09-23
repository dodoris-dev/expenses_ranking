require 'rails_helper'

RSpec.describe Expense, type: :model do
  it "is not valid without a liquid_value" do
    expense = Expense.new(liquid_value: nil)
    expect(expense).to_not be_valid
  end

  it "is not valid without a supplier" do
    expense = Expense.new(supplier: nil)
    expect(expense).to_not be_valid
  end

  it "is not valid without an issue_date" do
    expense = Expense.new(issue_date: nil)
    expect(expense).to_not be_valid
  end

  it "is not valid without an invoice_url" do
    expense = Expense.new(invoice_url: nil)
    expect(expense).to_not be_valid
  end

  it "calculates the amount correctly" do
    expense = Expense.new(liquid_value: 100.5678)
    expect(expense.amount).to eq(100.57)
  end

  it "belongs to a deputy" do
    assoc = Expense.reflect_on_association(:deputy)
    expect(assoc.macro).to eq(:belongs_to)
  end
end
