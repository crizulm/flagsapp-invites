Rails.application.routes.draw do
  post 'invites', to: 'invites#create', as: 'invites'
  get 'invites/:token', to: 'invites#show', as: 'invite'
  delete 'invites/:token', to: 'invites#destroy'
end
