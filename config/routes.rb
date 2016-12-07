Rails.application.routes.draw do
  
  	get 'loja' => 'loja#index', as: :loja
  	get 'busca_cidades/:state' => 'loja#busca_cidades', as: :busca_cidades
  	get 'cardapio/:state/:neighbor/:id/:size' => 'loja#cardapio', as: :cardapio
  	post 'login' => 'loja#login', as: :login
  	get 'pizzas' => 'loja#pizzas', as: :pizzas
  	get 'modeljson' => 'loja#modeljson', as: :modeljson
  	get 'cart' => 'loja#cart', as: :cart
  	post 'add_cart' => 'loja#add_cart', as: :add_cart
    get 'del/:name' => 'loja#del', as: :del

    get 'home' => 'home#index', as: :home

    get 'auth/facebook' => 'loja#loginfacebook', as: :auth_provider
    get 'auth/facebook/callback' => 'loja#loginfacebook'
    get 'auth/failure' => 'loja#login#failure', as: "auth_failure"

    root 'home#index'
    
end