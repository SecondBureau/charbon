module Lizard  
  module V1
    class Categories < Grape::API
      include Lizard::V1::Defaults
      
      resource :categories do
      
        desc 'Return all categories.'
        get '', jbuilder: 'categories' do
          @categories = CamaleonCms::Category.includes(:metas).all
        end
      end
      
    end
  end
end