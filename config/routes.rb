Rails.application.routes.draw do
  post 'invites', to: 'invites#create', as: 'invites'
  get 'invites/:token', to: 'invites#show', as: 'invite'
  delete 'invites/:id', to: 'invites#destroy'

  get 'healthcheck', to: 'ok_computer/ok_computer#index'
end
