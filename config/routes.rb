Rails.application.routes.draw do
  get 'modulos/carregar_dominoos'

  root :to => "users#cadastrar"
  resources :clientes
  resources :livro do end
  resources :categoria do end
  resources :users  do
    collection do
      get :login
      get :cadastrar
      post :registrar_usuario
      post :enviar_codigo_ativacao
      post :ativar_usuario
    end
  end
  get '/login' => 'users#login'
  post '/login' => 'users#login'
  get '/logout' => 'users#logout'

  resources :system  do
    collection do
      get :dashboard
    end
  end

  resources :profiles  do
    collection do
      post :update_resources
      post :salvar_permissao
    end
  end

  resources :condominios  do
    collection do
      get :preview
    end
  end

  resources :condominio_arquivos do
    collection do
      get :preview
      get :download
      get :assistente
      post :assistente1
      get :assistente_cancelar
      get :carregar_arquivos_do_exercicio
    end
  end

  resources :modulos do
    collection do
      get :carregar_dominos
    end
  end

  resources :esic do
    collection do
      get :index
      get :responder
      post :responder
      get :visualizar_resposta
      get :cancelar_solicitacao
      post :solicitar
    end
  end
end
