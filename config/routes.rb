Rails.application.routes.draw do
  mount Lizard::Base => '/'
  mount GrapeSwaggerRails::Engine, at: "/documentation"
end
