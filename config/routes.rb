Rails.application.routes.draw do
  
  	get 'loja' => 'loja#index', as: :loja
  	get 'busca_cidades/:state' => 'loja#busca_cidades', as: :busca_cidades
  	get 'cardapio/:state/:neighbor/:id/:size' => 'loja#cardapio', as: :cardapio
  	post 'login' => 'loja#login', as: :login
  	get 'pizzas' => 'loja#pizzas', as: :pizzas
  	get 'modeljson' => 'loja#modeljson', as: :modeljson
  	get 'cart' => 'loja#cart', as: :cart
  	
    get 'home' => 'home#index', as: :home

    root 'home#index'
    
end