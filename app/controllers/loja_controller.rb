class LojaController < ApplicationController
  def index
  	@states = Store.distinct(:state)
  end

  def rss
    redirect_to root_path
  end

  def busca_cidades
    consult = RestClient.get 'https://maps.googleapis.com/maps/api/geocode/json?address='+params[:cep][:numero]+'+'+params[:cep][:logradouro].gsub(" ","+")+',+'+params[:cep][:localidade].gsub(" ","+")+',+'+params[:cep][:uf].gsub(" ","+")+'&key=AIzaSyA4VtmtyiHJXI_l5esvm_7Vhdw8epH_3_Q'
    # Google Api Key = AIzaSyA4VtmtyiHJXI_l5esvm_7Vhdw8epH_3_Q
    @address = JSON.parse(consult)

    ids = Mongoid.default_client["zones"].find(area:
        { "$geoIntersects" =>
          { "$geometry" =>
              { type: "Point", coordinates: [@address['results'][0]['geometry']['location']['lat'], @address['results'][0]['geometry']['location']['lng']] }
          }
        }
      )

    if ids.count == 0
      @states = Store.distinct(:state)
      @error_cep = true
      render 'index'
    else

      @store = Store.mapStores([Store.find(ids.distinct(:store_id).first)]).first
      session[:store] = {}
      session[:store][:id] = @store[:id].to_s
      session[:store][:name] = @store[:name]
      session[:store][:uf] = params[:cep][:uf]
      session[:user] = {}
      session[:user][:bairro] = params[:cep][:bairro]
      session[:user][:cep] = params[:cep][:cep]
      session[:user][:uf] = params[:cep][:uf]
      session[:user][:localidade] = params[:cep][:localidade]
      session[:user][:logradouro] = params[:cep][:logradouro]
      session[:user][:number] = params[:cep][:numero] 

      redirect_to cardapio_path
    end

  end

  def cardapio
    if session[:store].blank? && session[:user].blank?
      redirect_to loja_path
    else
      @states = Store.distinct(:state)
      @neighborhood = Store.where(:state => session[:store]['uf'])
      @store = Store.find(session[:store]['id'])

      render stream: true
    end
  end

  def cep
    @states = Store.distinct(:state)
    consult = RestClient.get 'http://viacep.com.br/ws/'+params[:cep][:cep]+'/json/'
    @address = JSON.parse(consult)
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

    RestClient.post('http://pizzaprime.herokuapp.com/webservices/login/signinFacebook',  {  name: @user['name'].to_s, email: @user['email'].to_s, facebook: @user['id'].to_s  }){ |response, request, result| 

      cookies[:session_id] = response.cookies['_session_id']
      
      resultado = JSON.parse(response.body)
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

    }
    
  end
  
  def pizzas
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/stores/getStores', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        render json: response
    }
  end

  def cart
  end

  def checkout
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/cards', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @cards = JSON.parse(response.body)
    }

    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/addresses', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @addresses = JSON.parse(response.body)
    }

    @store = Store.find(session[:id])
  end

  def checkout_confirm
    redirect_to checkout_path
  end


  def del
    if session[:caixa] > 1
      session[:caixa] -= 1
      session[:pizzas].delete(params[:name])
    else
        session[:caixa] = nil
        session[:pizzas] = nil
    end

    redirect_to cart_path
  end

  def add_cart
    if session[:caixa].nil?
      session[:caixa] = 1
      session[:pizzas] = {}
    else
      if session[:pizzas][params[:cart][:name]].nil?
        session[:caixa] += 1
      end
    end
    
    session[:pizzas][params[:cart][:name]] = {}
    session[:pizzas][params[:cart][:name]][:size_id] = params[:cart][:size]
    session[:pizzas][params[:cart][:name]][:border_id] = params[:cart][:borders]
    session[:pizzas][params[:cart][:name]][:quantity] = params[:cart][:quantity].to_i
    if params[:cart][:integral] == '1'
      session[:pizzas][params[:cart][:name]][:integral] = true
    else
      session[:pizzas][params[:cart][:name]][:integral] = false
    end
    session[:pizzas][params[:cart][:name]][:obs] = params[:cart][:obs]
    session[:pizzas][params[:cart][:name]][:fidelity] = true
    
    if params[:cart][:sabor2] == 'none'
      session[:pizzas][params[:cart][:name]][:tastes] = [ { :id => params[:cart][:sabor1] } ]
    else
      session[:pizzas][params[:cart][:name]][:tastes] = [ { :id => params[:cart][:sabor1] }, { :id => params[:cart][:sabor2] } ]
    end

    redirect_to cardapio_path(session[:state],session[:neighbor],session[:id],session[:size])
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