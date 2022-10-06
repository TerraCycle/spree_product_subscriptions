Spree::Core::Engine.routes.draw do
  scope '(:locale)', locale: /#{Spree.available_locales.join('|')}/, defaults: { locale: nil } do
    namespace :admin do
      resources :subscription_frequencies
      resources :subscription_label_statuses
      resources :subscriptions, except: [:new, :destroy, :show] do
        member do
          patch :pause
          patch :unpause
          get :cancellation
          patch :cancel
        end
      end
    end

    resources :subscriptions, except: [:new, :destroy, :index, :show] do
      member do
        patch :pause
        patch :unpause
        patch :cancel
        patch :update_payment_details
        get :edit_payment_details
      end
    end
  end
end
