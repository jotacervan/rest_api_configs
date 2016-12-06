class HomeController < ApplicationController
  def index
      @combos = Combo.all
      @stores = Store.all
  end

  
end
