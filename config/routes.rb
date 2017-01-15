Rails.application.routes.draw do
  mount Lizard::Base => '/'
  mount GrapeSwaggerRails::Engine, at: "/documentation"
  get 'cpsearch', to: 'camaleon_cms/frontend#search_cp'
end
