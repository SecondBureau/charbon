require "grape-swagger"

module Lizard  
  module V1
    class Base < Grape::API
      mount Lizard::V1::Posts
      mount Lizard::V1::Users
      mount Lizard::V1::Themes
      mount Lizard::V1::Categories
      
      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end  