module Lizard  
  module V1
    class Themes < Grape::API
      include Lizard::V1::Defaults

      resource :themes do
  
        route_param :theme_slug do
          desc "get a theme"
          get '/' do
            theme = CamaleonCms::Theme.find_by_slug(params[:theme_slug])
          end
    
          resources :fields do
            desc "get theme field"
            route_param :field_slug do 
              get '/', jbuilder: 'theme_field' do
                theme = CamaleonCms::Theme.find_by_slug(params[:theme_slug])
                @theme = theme
                @field_slug = params[:field_slug]
                @field_contents = ""
                @field_contents = theme.get_fields(@field_slug).try(:first) unless theme.nil?
              end
            end
          end
        end
      end
      
    end
  end
end