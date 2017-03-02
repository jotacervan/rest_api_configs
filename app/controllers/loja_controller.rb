class LojaController < ApplicationController

  def index
  	@states = Store.distinct(:state)
  end

  def rss
    redirect_to root_path
  end

  def tamanho
    session[:tamanho] = params[:id]
    redirect_to cardapio_path
  end

  def massa
    session[:massa] = params[:id]
    redirect_to cardapio_path
  end

  def borda
    session[:borda] = params[:id]
    redirect_to cardapio_path
  end

  def integral
    if session[:integral] == '1'
      session[:integral] = '0'
      redirect_to cardapio_path
    else
      session[:integral] = '1'
      redirect_to cardapio_path
    end
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

    redirect_to cardapio_path, notice: 'Logout efetuado com Sucesso'
  end

  def addaddress
    RestClient.post('http://pizzaprime.herokuapp.com/webservices/account/addAddress', { :name => params[:address][:name], :zip => params[:address][:cep], :street => params[:address][:street], :number => params[:address][:number], :state => params[:address][:state], :phone => params[:address][:phone], :city => params[:address][:city], :type => params[:address][:type].to_i, :complement => params[:address][:complement], :neighborhood => params[:address][:neighborhood]  }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Endereço inserido com Sucesso'
        #render json: response.body

    }
  end

  def addcard
    opa = params[:card][:vencimento].split('/')
    cartao = params[:card][:number].split('-')
    nome = "Terminado em #{cartao[3]}"
    card = PagarMe::Card.new({
      :card_number => params[:card][:number].gsub('-', ''),
      :card_holder_name => params[:card][:titular],
      :card_expiration_month => opa[0],
      :card_expiration_year => opa[1],
      :card_cvv => params[:card][:cvv]
    });

    teste = card.create

    RestClient.post('http://pizzaprime.herokuapp.com/webservices/account/addCard', { :name => nome, :brand => teste.brand, :cpf => params[:card][:cpf], :id => teste.id   }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Cartão inserido com Sucesso'
        #render json: response.body

    }
  end

  def removecard
    RestClient.delete('http://pizzaprime.herokuapp.com/webservices/account/removeCard', :params => { 'card' => params[:id] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Cartão removido com Sucesso'
        #render json: response.body

    }
  end

  def removeaddress
    RestClient.delete('http://pizzaprime.herokuapp.com/webservices/account/removeAddress', :params => { 'address' => params[:id] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Endereço removido com Sucesso'
        #render json: response.body

    }
  end

  def updateabout
    RestClient.put('http://pizzaprime.herokuapp.com/webservices/account/updateAbout', { :phone => params[:datas][:phone], :name => params[:datas][:name], :gender => params[:datas][:gender] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Perfil Editado com Sucesso'
        #render json: response.body

    }
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
      if session[:massa].nil?
        session[:massa] = 'Fina'
      end
      if session[:tamanho].nil?
        session[:tamanho] = @store.tamanhos.last.id.to_s
      end
      if session[:borda].nil?
        session[:borda] = @store.borders.first.id.to_s
      end
    end
  end

  def cep
    @states = Store.distinct(:state)
    consult = RestClient.get 'http://viacep.com.br/ws/'+params[:cep][:cep]+'/json/'
    @address = JSON.parse(consult)
  end

  def login
    RestClient.post('http://pizzaprime.herokuapp.com/webservices/login/signin',  {  email: params[:login][:email], password: params[:login][:password]  }){|response, request|

    if response.code == 200
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

      redirect_to cardapio_path, :notice => 'Login efetuado com sucesso'
    else
      if response.code == 401
        redirect_to cardapio_path, :alert => 'Usuário não encontrado, Cadastre-se para continuar!'
      elsif response.code == 402
        redirect_to cardapio_path, :alert => 'Senha incorreta!'
      else
        redirect_to cardapio_path, :alert => 'Não foi possível efetuar o login corretamente, por favor tente novamente mais tarde!'
      end
      
    end
    
    }

  end


  def profile 
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/about', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        if response.code == 401
          session[:logged] = nil
          redirect_to cardapio_path, :alert => 'Faça o login para continuar'
        elsif response.code == 500
          redirect_to cardapio_path, :alert => 'Faça o login para continuar'
        else
          @store = Store.find(session[:store]['id'])
          @about = JSON.parse(response.body)
        end
    }
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/cards', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @cards = JSON.parse(response.body)
    }

    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/addresses', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @addresses = JSON.parse(response.body)
    }
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

      redirect_to cardapio_path

    }
    
  end
  
  def bebidas
    if session[:logged].blank?
      session[:bebidas] = nil
      render json: 'Bebidas', status: 302
    else
      if session[:bebidas].blank?
        session[:bebidas] = {}
        session[:bebidas][params[:id]] = { :qtd => 1, :price => params[:price] }
        render json: 'Bebidas', status: 200
      else
        session[:bebidas][params[:id]] = { :qtd => params[:qtd], :price => params[:price] }
      end
    end
    
  end



  def bebemenos
    if session[:bebidas].length > 1
      session[:bebidas].delete(params[:id])
    else
      session[:bebidas] = nil
    end

    redirect_to cart_path
  end



  def pizzas
    render json: params[:guide]
  end



  def cart
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/about', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        if response.code == 401
          session[:logged] = nil
          redirect_to cardapio_path, :alert => 'Faça o login para continuar'
        elsif response.code == 500
          redirect_to cardapio_path, :alert => 'Faça o login para continuar'
        else
          @store = Store.find(session[:store]['id'])
          @about = JSON.parse(response.body)
        end
    }
  end

  def checkout
    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/cards', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @cards = JSON.parse(response.body)
    }

    RestClient.get('http://pizzaprime.herokuapp.com/webservices/account/addresses', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @addresses = JSON.parse(response.body)
    }

    @store = Store.find(session[:store]['id'])
  end

  def checkout_confirm

    @pedido = {} 
    @pedido[:pedido] = {}
    @pedido[:pedido][:pizzas] = []
    session[:pizzas].each do |key, p|
        novo = p
        @pedido[:pedido][:pizzas].push(novo)
    end # pizzas
    @pedido[:pedido][:sweet_pizzas] = {}
    @pedido[:pedido][:beverages] = []
    session[:bebidas].each do |key, p|
      novo = { :id => key, :qtd => p['qtd'], :fidelity => true }
      @pedido[:pedido][:beverages].push(novo)
    end 

    if params[:checkout][:address] == 'Retirada na Loja'
      RestClient.post('http://pizzaprime.herokuapp.com/webservices/orders/createOrder', { :pedido => @pedido, :store_id => session[:store]['id'], :pic_in_store => true, :payment_id => params[:checkout][:payment] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to cardapio_path, notice: 'Pedido Enviado com Sucesso'

      }
    else
      RestClient.post('http://pizzaprime.herokuapp.com/webservices/orders/createOrder', { :pedido => @pedido, :store_id => session[:store]['id'], :pic_in_store => true, :payment_id => params[:checkout][:payment], :address_id => params[:checkout][:address] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to cardapio_path, notice: 'Pedido Enviado com Sucesso'
        
      }
    end


    
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
    session[:pizzas][params[:cart][:name]][:pasta] = params[:cart][:massa]
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

    redirect_to cardapio_path, :notice => 'Pizza Adicionada com Sucesso!'
  end


  def edit_cart

    session[:pizzas][params[:cart][:name]] = {}
    session[:pizzas][params[:cart][:name]][:size_id] = params[:cart][:size]
    session[:pizzas][params[:cart][:name]][:border_id] = params[:cart][:borders]
    session[:pizzas][params[:cart][:name]][:quantity] = params[:cart][:quantity].to_i
    session[:pizzas][params[:cart][:name]][:pasta] = params[:cart][:massa]
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

    redirect_to cart_path

  end


  def modeljson

    #pedido = { 
    #
    #  :pedido => {
#
 #       :pizzas => {
  #        :size_id => '2222',
   #       :border_id => '11111',
    #      :quantity => 1,
     #     :integral => true,
      #    :obs => 'Observações',
        #  :pasta => Fina,
       #   :fidelity => true,
        #  :tastes => {
#            :id => '123123',
 #           :id => '123123'
  #        }
   #     },
# 
 #       :sweet_pizzas => {
  #        :size_id => '2222',
   #       :quantity => 1,
    #      :obs => 'Observações',
      #    :pasta => Fina,
     #     :integral => true,
      #    :fidelity => true,
       #   :tastes => {
        #    :id => '123123',
         #   :id => '123123'
 #         }
  #      },
#
 #       :beverages => {
  #        :id => '123',
   #       :quantity => 1,
    #      :fidelity => true
     #   },
#
 #       :combos => {
  #        :id => '1234',
   #       :quantity => 1,
    #      :pizzas => {},
     #     :sweet_pizzas => {},
      #    :beverages => {}
       # }
#
#      }
#
 #   }
#
 #   render json: pedido

  end

end