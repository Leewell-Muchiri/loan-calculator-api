class LoansController < ApplicationController
    before_action :set_loan, only: [:show, :update, :destroy]
  
    def index
      @loans = Loan.all
      render json: @loans
    end
  
    def show
      render json: @loan
    end
  
    def create
      @loan = Loan.new(loan_params)
  
      if @loan.save
        compute_payment_amount(@loan)
        render json: @loan, status: :created
      else
        render json: @loan.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @loan.update(loan_params)
        compute_payment_amount(@loan)
        render json: @loan
      else
        render json: @loan.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @loan.destroy
    end
  
    private
  
    def set_loan
      @loan = Loan.find(params[:id])
    end
  
    def loan_params
      params.require(:loan).permit(:loan_amount, :payment_frequency, :loan_period, :start_date, :interest_type, :bank_id)
    end
  
    def compute_payment_amount(loan)
        if loan.interest_type == 'Flat Rate'
            loan.payment_amount = calculate_flat_rate_payment(loan)
        elsif loan.interest_type == 'Reducing Balance Rate'
            loan.payment_amount = calculate_reducing_balance_rate_payment(loan)
        end
    end
  
    def calculate_flat_rate_payment(loan)

        amortization_schedule = []

        loan_amount = loan.loan_amount
        monthy_rate = loan.bank.flat_rate_payment / 12 / 100
        period_in_months loan.loan_period * 12

        payment = (loan_amount + (loan_amount * monthy_rate * period_in_months)) / period_in_months 

        remaining_balance = loan_amount
        interest_payment = (remaining_balance * monthy_rate).round(2)

        period_in_months.times do |month|
            principal_payment = payment - interest_payment
            remaining_balance -= principal_payment

            amortization_schedule << {
                payment_number: month + 1,
                payment_date: loan.start_date + month.months,
                principal_payment: principal_payment.round(2),
                interest_payment: interest_payment.round(2),
                remaining_balance: remaining_balance.round(2)
            }
        end

        loan.amortization_schedule = amortization_schedule
        loan.save

        payment

    end
  end
  