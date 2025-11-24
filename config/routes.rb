Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/,
constraints: ApiConstraints.new(version: 2, default: true) do
      constraints(id: %r{[^/]+}) do
        resources :compute_resources, except: %i[new edit] do
          get :available_vnic_profiles, on: :member
        end
      end
    end
  end
end
