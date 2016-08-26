module Lizard  
  module Charbon
    
    class SharingMessage
      attr_accessor :to, :from, :postId, :message
    end
    
    
    class API < Grape::API
      include Lizard::V1::Defaults
      
      resource :sharing do
      
        post '/' do
          debugger
          message = SharingMessage.new
          
          
          %w( to from postId message).each do |a|
            message.send("#{a}=", params[:data][a.to_sym])
          end
          
          CamaleonCms::HtmlMailer.sender(email_to, args[:subject], args).deliver_later
        end
      end

        
        
      
    end
  end
end
      