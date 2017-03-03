Rails.application.routes.draw do
    
  	get 'loja' => 'loja#index', as: :loja
  	post 'busca_cidades' => 'loja#busca_cidades', as: :busca_cidades
  	get 'cardapio' => 'loja#cardapio', as: :cardapio
    get 'cardapio/:guia' => 'loja#cardapio'
  	post 'login' => 'loja#login', as: :login
  	get 'pizzas/:guide' => 'loja#pizzas', as: :pizzas
  	get 'modeljson' => 'loja#modeljson', as: :modeljson
  	get 'cart' => 'loja#cart', as: :cart
    get 'checkout' => 'loja#checkout', as: :checkout
    post 'checkout_confirm' => 'loja#checkout_confirm', as: :checkout_confirm
  	post 'add_cart' => 'loja#add_cart', as: :add_cart
    post 'edit_cart' => 'loja#edit_cart', as: :edit_cart
    get 'del/:name' => 'loja#del', as: :del
    post 'cep' => 'loja#cep', as: :cep
    post 'rss' => 'loja#rss', as: :rss
    get 'tamanho/:id' => 'loja#tamanho', as: :tamanho
    get 'massa/:id' => 'loja#massa', as: :massa
    get 'borda/:id' => 'loja#borda', as: :borda
    get 'integral' => 'loja#integral', as: :integral
    get 'bebidas/:price/:id/:qtd' => 'loja#bebidas', as: :bebidas
    get 'bebemenos/:id' => 'loja#bebemenos', as: :bebemenos
    get 'profile' => 'loja#profile', as: :profile

    get 'removeaddress/:id' => 'loja#removeaddress', as: :removeaddress
    get 'removecard/:id' => 'loja#removecard', as: :removecard

    post 'updateabout' => 'loja#updateabout', as: :updateabout
    post 'addaddress' => 'loja#addaddress', as: :addaddress
    post 'addcard' => 'loja#addcard', as: :addcard
    get 'cadastre' => 'home#cadastre', as: :cadastre

    post 'novouser' => 'home#novouser', as: :novouser

    get 'home' => 'home#index', as: :home
    get 'logout' => 'loja#logout', as: :logout

    get 'auth/facebook' => 'loja#loginfacebook', as: :auth_provider
    get 'auth/facebook/callback' => 'loja#loginfacebook'
    get 'auth/failure' => 'loja#login#failure', as: "auth_failure"

    root 'home#index'
     
end