module Lizard  
  module Charbon
    class API < Grape::API
      include Lizard::V1::Defaults
      
      resource :sharing do
      
        post '/' do
          "ok"
        end
      end

        
        
      
    end
  end
end
      