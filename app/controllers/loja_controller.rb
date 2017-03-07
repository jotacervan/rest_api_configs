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

    redirect_to home_path, notice: 'Logout efetuado com Sucesso'
  end

  def addaddress
    RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/account/addAddress', { :name => params[:address][:name], :zip => params[:address][:cep], :street => params[:address][:street], :number => params[:address][:number], :state => params[:address][:state], :phone => params[:address][:phone], :city => params[:address][:city], :type => params[:address][:type].to_i, :complement => params[:address][:complement], :neighborhood => params[:address][:neighborhood]  }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
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

    RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/account/addCard', { :name => nome, :brand => teste.brand, :cpf => params[:card][:cpf], :id => teste.id   }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Cartão inserido com Sucesso'
        #render json: response.body

    }
  end

  def removecard
    RestClient.delete('http://dev-pizzaprime.herokuapp.com/webservices/account/removeCard', :params => { 'card' => params[:id] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Cartão removido com Sucesso'
        #render json: response.body

    }
  end

  def removeaddress
    RestClient.delete('http://dev-pizzaprime.herokuapp.com/webservices/account/removeAddress', :params => { 'address' => params[:id] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        redirect_to profile_path, notice: 'Endereço removido com Sucesso'
        #render json: response.body

    }
  end

  def updateabout
    RestClient.put('http://dev-pizzaprime.herokuapp.com/webservices/account/updateAbout', { :phone => params[:datas][:phone], :name => params[:datas][:name], :gender => params[:datas][:gender] }, :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
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
  
  def selend
    @address = Address.find(params[:id])

    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/stores/getAvailableStores', { :params => {  zip: @address.zip, address_id: @address.id  },  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
      if response.code == 340
        redirect_to cardapio_path, alert: 'Ainda não há nenhuma loja que atende a sua região. Cadastre um endereço diferente em Meu Perfil'
      elsif response.code == 401
        redirect_to cardapio_path, alert: 'Faça o login para continuar'
      elsif response.code == 500
        redirect_to cardapio_path, alert: 'Não foi possivel checar seu endereço, por favor tente novamente mais tarde'
      else
        @addresses = JSON.parse(response.body)
        if @addresses.length == 1
          session[:address_id] = @address.id.to_s
          session[:store] = {}
          session[:store][:id] = @addresses[0]['id'].to_s
          session[:store][:name] = @addresses[0]['name']
          session[:store][:uf] = @address.state
          session[:user] = {}
          session[:user][:bairro] = @address.neighborhood
          session[:user][:cep] = @address.zip
          session[:user][:uf] = @address.state
          session[:user][:localidade] = @address.city
          session[:user][:logradouro] = @address.street
          session[:user][:number] = @address.number 

          #render json: { :address => session[:address_id], :loja => session[:store], :user => session[:user] }
        else
          #render json: 'Escolha uma loja'
        end
        redirect_to cardapio_path
      end  
    }

    
  end

  def cardapio_state
    if session[:store].blank? && session[:user].blank?
      redirect_to loja_path
    else
      @states = Store.distinct(:state)
      @neighborhood = Store.where(:state => params[:state])

      @store = Store.find(@neighborhood.first.id)
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

    render 'cardapio_state_name'
  end

  def cardapio_state_name
    if session[:store].blank? && session[:user].blank?
      redirect_to loja_path
    else
      @states = Store.distinct(:state)
      @neighborhood = Store.where(:state => params[:state])
      
      @store = Store.find(params[:name])
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

      if session[:address_id].nil?
        if session[:logged] == true
          RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/addresses', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
              @addresses = JSON.parse(response.body)
          }

          if @addresses.length == 0
            flash[:notice] = 'Nenhum endereço cadastrado, Por favor entre em seu perfil para completar o cadastro!'
          else
            @addresses.each do |a|
              if a['zip'] == session[:user]['cep']
                session[:address_id] = a['id']
              end
            end

            if session[:address_id].nil?
              
            else
              @addresses = nil
            end
            
          end
          
        else
          # Endereço não definido e login não efetuado
        end
        
      else
        # Já foi definido o endereço
      end
      
    end
  end

  def cep
    @states = Store.distinct(:state)
    consult = RestClient.get 'http://viacep.com.br/ws/'+params[:cep][:cep]+'/json/'
    @address = JSON.parse(consult)
  end

  def login
    RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/login/signin',  {  email: params[:login][:email], password: params[:login][:password]  }){|response, request|

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
    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/about', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
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
    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/cards', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @cards = JSON.parse(response.body)
    }

    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/addresses', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @addresses = JSON.parse(response.body)
    }
  end


  def loginfacebook
    @user = User.koala(request.env['omniauth.auth']['credentials'])

    RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/login/signinFacebook',  {  name: @user['name'].to_s, email: @user['email'].to_s, facebook: @user['id'].to_s  }){ |response, request, result| 

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
    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/about', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
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
    RestClient.get('http://dev-pizzaprime.herokuapp.com/webservices/account/cards', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        @cards = JSON.parse(response.body)
    }

    @store = Store.find(session[:store]['id'])
  end

  def checkout_confirm

    @pedido = {} 
    @pedido[:pizzas] = []
    session[:pizzas].each do |key, p|
        novo = p
        @pedido[:pizzas].push(novo)
    end # pizzas
    @pedido[:sweet_pizzas] = []
    if session[:sweet_pizzas].nil?
    else
      session[:sweet_pizzas].each do |key, p|
          novo = p
          @pedido[:sweet_pizzas].push(novo)
      end # sweet_pizzas
    end
    @pedido[:beverages] = []
    if session[:bebidas].nil?
    else
      session[:bebidas].each do |key, p|
        novo = { :id => key, :quantity => p['qtd'], :fidelity => false }
        @pedido[:beverages].push(novo)
      end 
    end

    @pedido[:store_id] = session[:store]['id']    
    @pedido[:payment_id] = params[:checkout][:payment]

    if Payment.find(params[:checkout][:payment]).is_app == true
      @pedido[:card_id] = params[:checkout][:card]
    end

    @pedido[:address_id] = session[:address_id]
    @pedido[:obs] = params[:checkout][:obs]

    if params[:checkout][:address] == 'Retirada na Loja'

      @pedido[:pick_in_store] = 1
      RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/orders/createOrder',  @pedido  , :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        @resposta = JSON.parse(response.body)
        #redirect_to cardapio_path, notice: 'Pedido Enviado com Sucesso'
      }
    else
      
      RestClient.post('http://dev-pizzaprime.herokuapp.com/webservices/orders/createOrder',   @pedido  , :cookies => { '_session_id' => cookies[:session_id] } ){ |response, request, result, &block|
        
        @resposta = JSON.parse(response.body)
        #redirect_to cardapio_path, notice: 'Pedido Enviado com Sucesso'
         
      }
    end
    
    @states = Store.distinct(:state)
    
  end #checkout confirm

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
    session[:pizzas][params[:cart][:name]][:fidelity] = false
    
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
    session[:pizzas][params[:cart][:name]][:fidelity] = false
    
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