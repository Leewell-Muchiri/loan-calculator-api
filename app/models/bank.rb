class Bank < ApplicationRecord
    validates :name, presence: true
    validates :flat_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :reducing_balance_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

    has_many :loans
end