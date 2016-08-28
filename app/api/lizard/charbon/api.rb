module Lizard  
  module Charbon
    
    
    class ContactFormMessage
      attr_accessor :from, :title, :message
    end
    
    
    
    class SharingMessage
      attr_accessor :to, :from, :postId, :message, :postPath, :featuredImagePath
      
      def post
        @post ||= CamaleonCms::Post.find(postId)
      end
      
      def title
        post.title
      end
      
      def summary
        post.get_meta("summary") 
      end
      
    end
    
    
    class API < Grape::API
      include Lizard::V1::Defaults
      
      resource :sharing do
      
        post '/' do
          message = SharingMessage.new
          %w( to from postId message postPath featuredImagePath).each do |a|
            message.send("#{a}=", params[:data][a.to_sym])
          end
          
          begin

            subject = "#{message.title} @ China India Dialogue"
            
            data = {  message: message.message, 
                      post_path: message.postPath, 
                      featured_image_path: message.featuredImagePath, 
                      title: message.title, 
                      summary: message.summary} 
            
            args = {  extra_data: data, 
                      template_name: 'html_mailer/sharing', 
                      layout_name: 'mailer', 
                      from: message.from, 
                      url_base: request.host_with_port, 
                      current_site: CamaleonCms::Site.first }
            
            message.to.split(',').each  do |email_to|
              CamaleonCms::HtmlMailer.sender(email_to.strip, subject, args).deliver_now
            end
            
          rescue Exception => e
            error!
          end
        end
      end
      
      
      resource :contactform do
      
        post '/' do
          
          message = ContactFormMessage.new
          %w( from title message).each do |a|
            message.send("#{a}=", params[:data][a.to_sym])
          end
          
          begin
            
            email_to = ENV['CONTACT_FORM_TO']

            subject = "#{message.title} @ China India Dialogue"
            
            data = {  message: message.message } 
            
            args = {  extra_data: data, 
                      template_name: 'html_mailer/contact_form', 
                      layout_name: 'mailer', 
                      from: message.from, 
                      url_base: request.host_with_port, 
                      current_site: CamaleonCms::Site.first }
                      
            CamaleonCms::HtmlMailer.sender(email_to, subject, args).deliver_now
            
          rescue Exception => e
            error!
          end
          
        end
      end

        
        
      
    end
  end
end
