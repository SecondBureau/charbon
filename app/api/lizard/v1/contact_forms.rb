class MyKlass
  include Plugins::ContactForm::ContactFormHtmlHelper
  include CamaleonCms::HooksHelper
  include CamaleonCms::CaptchaHelper
  include Rails.application.routes.url_helpers
  
  def current_site
    CamaleonCms::Site.first
  end
  
  def current_theme
    CamaleonCms::Theme.find_by_slug('china_india_dialogue')
  end
  
  def self.get_form_submit(form)
    values_fields =  {}
    values = JSON.parse(form.value).to_sym
    settings = JSON.parse(form.settings).to_sym
    r = {form: form, form_class: "railscf-form railscf-form-group", before_form: "", after_form: "", submit: "<div class='form-group'><button class='submit_btn btn btn-default pull-right' type='submit'>[submit_label]</button></div>"}
    #hooks_run("contact_form_render", r)
    if values[:fields].present?
        r[:submit].sub('[submit_label]', settings[:railscf_form_button][:name_button])
    else
        ""
    end
    
  end
  
  def self.get_form_content(form)
    #values_fields =  (flash[:values].present?)? flash[:values].to_sym : {}
    values_fields =  {}
    values = JSON.parse(form.value).to_sym
    settings = JSON.parse(form.settings).to_sym
    r = {form: form, form_class: "railscf-form railscf-form-group", before_form: "", after_form: "", submit: "<div class='form-group'><button class='submit_btn btn btn-default pull-right' type='submit'>[submit_label]</button></div>"}
    #hooks_run("contact_form_render", r)
    self.new.form_element_bootstrap_object(r[:form], values[:fields], values_fields)
  end
end

module Lizard  
  module V1
    class ContactForms < Grape::API
      include Lizard::V1::Defaults
      
      resource :contactform do 
      
        route_param :theme_slug do
        
          resources :forms do
      
            route_param :form_slug do
        
              desc "get form html"
              get '/', jbuilder: 'contact_form_form' do
                @theme = CamaleonCms::Theme.find_by_slug(params[:theme_slug])
                @form = Plugins::ContactForm::Models::ContactForm.find_by_slug(params[:form_slug])
                @form_fields = MyKlass.get_form_content @form
                @form_submit =  MyKlass.get_form_submit @form
                @flash_message_submitted = "Your message has been sent."
                @flash_message_error = "Error"
              end
            end
          end
        end
      end
    end
  end
end