Rails.application.routes.draw do
  resources :annotated_images do
    member do
      post 'update_annotation'
      get 'edit_annotation'
    end
    collection do
      get 'load_images'
    end
  end
  root 'welcome#home'
end
