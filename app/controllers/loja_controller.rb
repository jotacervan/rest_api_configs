class LojaController < ApplicationController
  def index
  	@states = Store.distinct(:state)
  end

  def busca_cidades
  	@states = Store.distinct(:state)
  	@selected = params[:state]
  	@neighborhood = Store.where(:state => params[:state])
  end

  def cardapio
  	@states = Store.distinct(:state)
  	@selected = params[:state]
  	@neighbor = params[:neighbor]
  	@id = params[:id]
  	@neighborhood = Store.where(:state => params[:state])
  	@store = Store.find(@id)
    @size = params[:size]
  end

  def login

    RestClient.post('http://pizzaprime.herokuapp.com/webservices/login/signin',  {  email: params[:login][:email], password: params[:login][:password]  }){ |response, request, result, &block|
        
        cookies[:session_id] = response.cookies['_session_id']
        redirect_to pizzas_path
        #render json: response.cookies['_session_id']

    }

  end
  
  def pizzas

    RestClient.get('http://pizzaprime.herokuapp.com/webservices/stores/getStores', {  :cookies => { '_session_id' => cookies[:session_id] }  } ){ |response, request, result, &block|
        
        render json: response

    }
    
  end

end