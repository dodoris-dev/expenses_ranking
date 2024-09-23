Rails.application.routes.draw do
  get "data/processing_csv", to: "data#processing_csv"

  resources :expenses
  resources :deputies do
    get "expenses_sum", to: "deputies#return_expenses_sum", on: :member
    get "highest_expense", to: "deputies#return_highest_expense", on: :member
    get "list_expenses", to: "deputies#list_expenses", on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  match "*path", to: "application#render_not_found", via: :all
end
