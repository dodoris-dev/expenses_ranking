class Deputy < ApplicationRecord
  include Deputies::ExpenseCalculable
  has_many :expenses

  validates :name, presence: true
  validates :party, presence: true
  validates :state, presence: true
  validates :cpf, presence: true, uniqueness: true
end
