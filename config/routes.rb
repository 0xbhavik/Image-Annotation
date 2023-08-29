Rails.application.routes.draw do
  resources :annotated_images do
    member do
      post 'update_annotation'
      get 'edit_annotation'
    end
  end
  root 'welcome#home'
end
