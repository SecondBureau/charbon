module Lizard  
  module V1
    class Users < Grape::API
      include Lizard::V1::Defaults

      resource :users do

        desc 'return a user'
        params do
          requires :id, type: Integer, desc: "User id."
        end
        route_param :id do 
          get '/', jbuilder: 'user' do
            @user = CamaleonCms::User.find_by_id!(params[:id])
          end
        end
      end
      
    end
  end
end