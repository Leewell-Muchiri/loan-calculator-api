class BanksController < ApplicationController
    before_action :set_bank, only: [:show, :update, :destroy]
  
    def index
      @banks = Bank.all
      render json: @banks
    end
  
    def show
      render json: @bank
    end
  
    def create
      @bank = Bank.new(bank_params)
  
      if @bank.save
        render json: @bank, status: :created
      else
        render json: @bank.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @bank.update(bank_params)
        render json: @bank
      else
        render json: @bank.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @bank.destroy
    end
  
    private
  
    def set_bank
      @bank = Bank.find(params[:id])
    end
  
    def bank_params
      params.require(:bank).permit(:name, :flat_rate, :reducing_balance_rate)
    end
  end
  
