Rails.application.routes.draw do
  #mount Lizard::Base => '/'
  #mount GrapeSwaggerRails::Engine, at: "/documentation"
  get 'cpsearch', to: 'camaleon_cms/frontend#search_cp'
  get 'cidsearch', to: 'camaleon_cms/frontend#search_cid'
  
  scope "(:locale)", locale: /#{PluginRoutes.all_locales}/, :defaults => {  } do
    scope :api do
      get 'cp_related_posts/:post_id', to: 'api#cp_posts_blocks_thumbnails'
    end
  end
end
