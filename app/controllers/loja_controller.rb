class LojaController < ApplicationController
  def index
  	@states = Store.distinct(:state)
  end

  def busca_cidades
  	@states = Store.distinct(:state)
  	@selected = params[:state]
  	@neighborhood = Store.where(:state => params[:state])
    #Session definition start
    session[:state] = @selected
    #Session definition end
  end

  def cardapio
  	@states = Store.distinct(:state)
  	@selected = params[:state]
  	@neighbor = params[:neighbor]
  	@id = params[:id]
  	@neighborhood = Store.where(:state => params[:state])
  	@store = Store.find(@id)
    @size = params[:size]
    #Session definition start
    session[:state] = @selected
    session[:neighbor] = @neighbor
    session[:id] = @id
    session[:size] = @size
    #Session definition end
  end

  def login
    consult = RestClient.post 'http://pizzaprime.herokuapp.com/webservices/login/signin',  {  email: params[:login][:email], password: params[:login][:password]  }

    cookies[:session_id] = consult.cookies['_session_id']
    
    resultado = JSON.parse(consult.body)
    session[:logged] = true
    session[:name] = resultado['name']
    session[:email] = resultado['email']
    session[:picture] = resultado['picture']
    session[:gender] = resultado['gender']
    session[:facebook] = resultado['facebook']
    session[:balance] = resultado['balance']
    session[:phone] = resultado['phone']
    session[:cpf] = resultado['cpf']

    redirect_to cardapio_path(session[:state],session[:neighbor],session[:id],session[:size])
    
  end

  def loginfacebook
    @user = User.koala(request.env['omniauth.auth']['credentials'])

    RestClient.post('http://pizzaprime.herokuapp.com/webservices/login/signinFacebook',  {  email: @user['email'], name: @user['name'], facebook: @user['id']  }){ |response, request, result| 


      render json: response


    }
    
  end
  
  def pizzas
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/stores/getStores', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        render json: response
    }
  end

  def cart
  end

  def add_cart
  end

  def modeljson

    pedido = { 

      :pedido => {

        :pizzas => {
          :size_id => '2222',
          :border_id => '11111',
          :quantity => 1,
          :integral => true,
          :obs => 'Observações',
          :fidelity => true,
          :tastes => {
            :id => '123123',
            :id => '123123'
          }
        },

        :sweet_pizzas => {
          :size_id => '2222',
          :quantity => 1,
          :obs => 'Observações',
          :integral => true,
          :fidelity => true,
          :tastes => {
            :id => '123123',
            :id => '123123'
          }
        },

        :beverages => {
          :id => '123',
          :quantity => 1,
          :fidelity => true
        },

        :combos => {
          :id => '1234',
          :quantity => 1,
          :pizzas => {},
          :sweet_pizzas => {},
          :beverages => {}
        }

      }

    }

    render json: pedido

  end

end