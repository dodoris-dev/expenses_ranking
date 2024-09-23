class Expense < ApplicationRecord
  belongs_to :deputy

  validates :liquid_value, presence: true
  validates :supplier, presence: true
  validates :issue_date, presence: true
  validates :invoice_url, presence: true

  def amount
    read_attribute(:liquid_value).to_f.round(2)
  end
end
