module Lizard  
  module V1
    class Posts < Grape::API
      include Lizard::V1::Defaults

      resource :posts do
        
        
        desc 'Return posts for homepage'
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

        desc 'Return posts.'
        params do 
          optional :limit, type: Integer, desc: "Number of records to return.<br> Defaut: 10"
          optional :offset, type: Integer, desc: "First record to return.<br> Defaut: 0"
          optional :s, type: String, default: "", desc: "Search criterias. JSON categories=[CatID], keywords: k='keyword1,keyword2', Excluded Posts: e=[], Min Date: min='YYYY-MM-DD', Max Date: max='YYYY-MM-DD', order: order='published_at desc'"
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
    
      end
    end
  end
end  