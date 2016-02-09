module Lizard  
  class Base < Grape::API
    mount Lizard::V1::Base
    mount Lizard::Charbon::API
  end
end 