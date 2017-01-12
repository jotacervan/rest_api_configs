class HomeController < ApplicationController

  def index
      @combos = Combo.all
      @stores = Store.all
  end

  def logout
  	cookies[:session_id] = nil
      
      
      session[:logged] = nil
      session[:name] = nil
      session[:email] = nil
      session[:picture] = nil
      session[:gender] = nil
      session[:facebook] = nil
      session[:balance] = nil
      session[:phone] = nil
      session[:cpf] = nil

      redirect_to cardapio_path, notice: 'Logout efetuado com sucesso!'
  end

end
