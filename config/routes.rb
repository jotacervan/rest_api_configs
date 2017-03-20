Rails.application.routes.draw do
    
  	get 'loja' => 'loja#index', as: :loja
  	post 'busca_cidades' => 'loja#busca_cidades', as: :busca_cidades
  	get 'cardapio' => 'loja#cardapio', as: :cardapio
    get 'cardapio/:state' => 'loja#cardapio_state', as: :cardapio_state
    get 'cardapio/:state/:name' => 'loja#cardapio_state_name', as: :cardapio_state_name
  	post 'login' => 'loja#login', as: :login
  	get 'pizzas/:guide' => 'loja#pizzas', as: :pizzas
  	get 'modeljson' => 'loja#modeljson', as: :modeljson
  	get 'cart' => 'loja#cart', as: :cart
    get 'checkout' => 'loja#checkout', as: :checkout
    post 'checkout_confirm' => 'loja#checkout_confirm', as: :checkout_confirm
    post 'add_combo' => 'loja#add_combo', as: :add_combo
  	post 'add_cart' => 'loja#add_cart', as: :add_cart
    post 'add_sweet' => 'loja#add_sweet', as: :add_sweet
    post 'edit_cart' => 'loja#edit_cart', as: :edit_cart
    post 'edit_sweet' => 'loja#edit_sweet', as: :edit_sweet
    get 'del/:name' => 'loja#del', as: :del
    get 'sweet_del/:name' => 'loja#sweet_del', as: :sweet_del
    post 'cep' => 'loja#cep', as: :cep
    post 'rss' => 'loja#rss', as: :rss
    get 'tamanho/:id' => 'loja#tamanho', as: :tamanho
    get 'massa/:id' => 'loja#massa', as: :massa
    get 'borda/:id' => 'loja#borda', as: :borda
    get 'integral' => 'loja#integral', as: :integral
    get 'bebidas/:price/:id/:qtd' => 'loja#bebidas', as: :bebidas
    get 'bebemenos/:id' => 'loja#bebemenos', as: :bebemenos
    get 'profile' => 'loja#profile', as: :profile
    get 'combo/:id' => 'loja#combo', as: :combo

    post 'applycoupon' => 'loja#applycoupon', as: :applycoupon

    get 'removeaddress/:id' => 'loja#removeaddress', as: :removeaddress
    get 'removecard/:id' => 'loja#removecard', as: :removecard

    get 'selend/:id' => 'loja#selend', as: :selend

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