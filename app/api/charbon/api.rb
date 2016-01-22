module Charbon
  class API < Grape::API
    version 'v1', using: :header, vendor: 'charbon'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    prefix :api
    
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
          @results[categoryId.to_i] = (CamaleonCms::Category.find(categoryId).posts[0, lim.to_i])
        end
      end
      
      desc 'return posts'
      params do 
        optional :limit, type: Integer
        optional :offset, type: Integer
        optional :s, type: String, default: ""
      end
      get '', jbuilder: 'posts' do
        @results = {}
        limit = params[:limit] || 10
        offset = params[:offset] || 0
        search = JSON.parse("{#{params[:s]}}")
        if search['category']
          posts = CamaleonCms::Post.joins(:categories).where('cama_term_taxonomy.id=?', search['category'].to_i)
        else
          posts = CamaleonCms::Post.all
        end  
        @posts = posts[offset, limit]
        header "x-pagination", {
          total: posts.size,
          total_pages: (posts.size / limit.to_f).ceil.to_i,
          current_page: (offset.to_i / limit.to_i) + 1,
          offset: offset,
          min_date: Time.now,
          max_date: Time.now
        }.to_json
      end
      
      desc 'Return a post.'
      params do
        requires :slug, type: String, desc: 'Post Slug.'
      end
      route_param :slug do
        get do
          CamaleonCms::Post.find_by_slug(params[:slug])
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