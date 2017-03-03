class HomeController < ApplicationController

  def index
      @combos = Combo.all
      @stores = Store.all
  end

  def cadastre
    @states = Store.distinct(:state)
  end

  def novouser
    RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/login/signup',  { name: params[:user][:name],  email: params[:user][:email], cpf: params[:user][:cpf], password: params[:user][:password]  }){|response, request|

    if response.code == 200

      redirect_to cardapio_path, :notice => 'Usuário criado com sucesso'
    else
      if response.code == 403
        redirect_to cardapio_path, :alert => 'Usuário já cadastrado, Faça o login para continuar!'
      elsif response.code == 500
        redirect_to cadastre_path, :alert => 'Não foi possível cadastrar usuário, por favor tente novamente mais tarde!'
      end
      
    end
    
    }
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
