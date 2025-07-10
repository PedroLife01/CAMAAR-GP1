Rails.application.routes.draw do
  get "respostas/create"
  resources :turmas
  get "formularios/index"
  get "formularios/new"
  get "formularios/create"
  get "formularios/show"
  get "home/index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Rotas de importação
  get  '/sigaa/importar',  to: 'sigaa_import#new'
  post '/sigaa/importar',  to: 'sigaa_import#create'

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "home#index"

  # resources
  resources :users
  resources :turmas do
    resources :turmas_alunos, only: [:create, :destroy]
    get 'buscar_alunos', on: :member
  end
  resources :formularios do
    member do
      get :respostas_anonimas
      get :exportar_respostas_anonimas
    end
    post 'enviar', on: :member
  end
  resources :respostas, only: [:create, :index, :show]
  resources :templates
end
