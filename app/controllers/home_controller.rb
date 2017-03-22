class HomeController < ApplicationController

  def index

    if session[:store].blank? && session[:user].blank?
      @combos = Combo.all
    else
      RestClient.get('http://pizzaprime.herokuapp.com/webservices/stores/getCombos', { :params => { store_id: session[:store]['id']  },  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        if response.code == 340
          redirect_to cardapio_path, alert: 'Ainda não há nenhuma loja que atende a sua região. Cadastre um endereço diferente em Meu Perfil'
        elsif response.code == 401
          redirect_to cardapio_path, alert: 'Faça o login para continuar'
          cookies[:session_id] = nil
          
          session[:address_id] = nil
          session[:store] = nil
          session[:user] = nil
          session[:logged] = nil
          session[:name] = nil
          session[:email] = nil
          session[:picture] = nil
          session[:gender] = nil
          session[:facebook] = nil
          session[:balance] = nil
          session[:phone] = nil
          session[:cpf] = nil
          session[:caixa] = nil
          session[:pizzas] = nil
          session[:bebidas] = nil
          session[:tamanho] = nil
          session[:massa] = nil
          session[:borda] = nil
          session[:integral] = nil
          session[:combo] = nil
          session[:coupon] = nil
        
        elsif response.code == 500
          redirect_to cardapio_path, alert: 'Não foi possivel checar seu endereço, por favor tente novamente mais tarde'
        else
          @combos = JSON.parse(response.body)
        end  
      }
    end
      @stores = Store.all
  end

  def cadastre
    @states = Store.distinct(:state)
  end
  
  def novouser
    RestClient.post('http://pizzaprime.herokuapp.com/webservices/login/signup',  { name: params[:user][:name],  email: params[:user][:email], cpf: params[:user][:cpf], password: params[:user][:password]  }){|response, request|

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

end
