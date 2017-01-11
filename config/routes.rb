Rails.application.routes.draw do
    
  	get 'loja' => 'loja#index', as: :loja
  	post 'busca_cidades' => 'loja#busca_cidades', as: :busca_cidades
  	get 'cardapio' => 'loja#cardapio', as: :cardapio
  	post 'login' => 'loja#login', as: :login
  	get 'pizzas' => 'loja#pizzas', as: :pizzas
  	get 'modeljson' => 'loja#modeljson', as: :modeljson
  	get 'cart' => 'loja#cart', as: :cart
    get 'checkout' => 'loja#checkout', as: :checkout
    post 'checkout_confirm' => 'loja#checkout_confirm', as: :checkout_confirm
  	post 'add_cart' => 'loja#add_cart', as: :add_cart
    get 'del/:name' => 'loja#del', as: :del
    post 'cep' => 'loja#cep', as: :cep
    post 'rss' => 'loja#rss', as: :rss

    get 'home' => 'home#index', as: :home

    get 'auth/facebook' => 'loja#loginfacebook', as: :auth_provider
    get 'auth/facebook/callback' => 'loja#loginfacebook'
    get 'auth/failure' => 'loja#login#failure', as: "auth_failure"

    root 'home#index'
    
end