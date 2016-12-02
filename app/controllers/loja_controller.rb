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

end