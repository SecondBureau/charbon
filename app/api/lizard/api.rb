
class MyKlass
  #include Plugins::ContactForm::ContactFormHtmlHelper
  include Plugins::CamaContactForm::MainHelper
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


module Charbon
  class API < Grape::API
    
    version 'v1', using: :header, vendor: 'charbon'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    prefix :api
    
    resource :sharing do
      
      post '/' do
        "ok"
      end
    end
    
    resource :themes do
      
      route_param :theme_slug do
        
        desc "get theme"
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
    
    resource :users do
      
      desc 'return user'
      route_param :user_id do 
        get '/', jbuilder: 'user' do
          @user = CamaleonCms::User.find_by_id(params[:user_id])
          
        end
      end
    end
    
    resource :categories do
      
      desc 'Return list of categories.'
      get '', jbuilder: 'categories' do
        @categories = CamaleonCms::Category.includes(:metas).all
      end
    end
    
    
    resource :posts do
      
      desc 'return posts for homepage'
      params do
        requires :q, type: String, desc: 'Query string'
      end
      get :home, jbuilder: 'homeposts' do
        @results = {}
        params[:q].split('|').each do |item|
          categoryId, lim = item.split(',')
          @results[categoryId.to_i] = (CamaleonCms::Category.find(categoryId).posts.eager_load(:metas)[0, lim.to_i])
        end
      end
      
      desc 'return posts'
      params do 
        optional :limit, type: Integer
        optional :offset, type: Integer
        optional :s, type: String, default: ""
      end
      get '/', jbuilder: 'posts' do
        @results = {}
        limit = params[:limit] || 10
        offset = params[:offset] || 0
        search = JSON.parse("#{params[:s]}")
        if search['categories'].is_a?(Array) && !search['categories'].blank?
          posts = CamaleonCms::Post.visible_frontend.eager_load(:metas).eager_load(:categories).joins(:categories).where('cama_term_taxonomy.id = any (array[?])', search['categories'])
        else
          posts = CamaleonCms::Post.visible_frontend.eager_load(:metas).eager_load(:categories).all
        end
        if search['k']
          keywords = search['k'].split(',').map{|k| "%#{k}%"}
          posts = posts.where("title ilike any (array[?]) or content ilike any (array[?])", keywords, keywords)
        end
        if search['e'].is_a?(Array) && !search['e'].blank?
          posts = posts.where.not(id: search['e'])
        end
        if search['min']
          begin
            posts = posts.where('published_at > ?', search['min'].to_date)
          rescue
          end
        end
        if search['max']
          begin
            posts = posts.where('published_at < ?', search['max'].to_date)
          rescue
          end
        end
        if search['order']  
          posts = posts.order(search['order'])
        end
        
        min_date = Time.now
        max_date = 100.years.ago
        posts.each do |p|
          min_date = p.published_at if min_date.nil? || p.published_at && p.published_at < min_date
          max_date = p.published_at if max_date.nil? || p.published_at && p.published_at > max_date
        end
        
        @posts = posts[offset, limit]
        header "x-pagination", {
          total: posts.size,
          total_pages: (posts.size / limit.to_f).ceil.to_i,
          current_page: (offset.to_i / limit.to_i) + 1,
          offset: offset,
          min_date: min_date,
          max_date: max_date
        }.to_json
      end
      
      desc 'Return a post.'
      params do
        requires :slug, type: String, desc: 'Post Slug.'
      end
      route_param :slug do
        get '/', jbuilder: 'posts' do
          @posts = [CamaleonCms::Post.find_by_slug(params[:slug])]
        end
      end
      
      
      # headers["x-pagination"] = {
      #   total: posts.size,
      #   total_pages: (posts.size / limit.to_f).ceil.to_i,
      #   current_page: (offset.to_i / limit.to_i) + 1,
      #   offset: offset,
      #   min_date: min_date,
      #   max_date: max_date
      #   }.to_json
      
      desc 'Return a public timeline.'
      get :test do
        "ok"
      end
    end
  end
end


# get '/posts' do
#   if params['q']
#     posts = []
#     params['q'].split('|').each do |item|
#       categoryId, lim = item.split(',')
#       p = Post.new.by_category(categoryId)
#       (posts << p[0, lim.to_i]).flatten!
#     end
#     limit = posts.size
#     offset = 0
#     @posts = posts
#   elsif params['s']
#     limit = params['limit'] || 10
#     offset = params['offset'] || 0
#     posts = Post.new.search(params['s'])
#     @posts = posts[offset.to_i, limit.to_i]
#   else
#     categoryId = params['category_id']
#     limit = params['limit'] || 10
#     offset = params['offset'] || 0
#     posts = categoryId.nil? ? Post.new.all : Post.new.by_category(categoryId)
#     @posts = posts[offset.to_i, limit.to_i]
#   end
#   min_date, max_date = posts.inject([]) do |r, e|
#     r[0] = e['published_at'] if ( r[0].blank? || e['published_at'] < r[0])
#     r[1] = e['published_at'] if ( r[1].blank? || e['published_at'] > r[1])
#     r
#   end
#   headers["x-pagination"] = {
#     total: posts.size,
#     total_pages: (posts.size / limit.to_f).ceil.to_i,
#     current_page: (offset.to_i / limit.to_i) + 1,
#     offset: offset,
#     min_date: min_date,
#     max_date: max_date
#     }.to_json
#   headers( "Access-Control-Allow-Origin" => "*" )
#   headers( "Access-Control-Expose-Headers" => "x-pagination")
#   jbuilder :posts
# end