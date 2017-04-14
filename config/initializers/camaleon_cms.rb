CamaleonCms::FrontendController.class_eval do 
  
  
  def search_cid
    breadcrumb_add(ct("search"))
    #items = params[:post_type_slugs].present? ? current_site.the_posts(params[:post_type_slugs].split(',')) : current_site.the_posts
    @cama_visited_search = true
    #@param_search = params[:q]
    layout_ = lookup_context.template_exists?("layouts/search") ? "search" : nil
    r = {layout: layout_, render: "search", posts: nil}; hooks_run("on_render_search", r)
    #params[:q] = (params[:q] || '').downcase
    #@posts = current_site.posts.published
    @posts = current_site.the_posts('post').published
      .joins("LEFT OUTER JOIN cama_metas ON cama_metas.objectid = cama_posts.id AND cama_metas.object_class = 'Post' AND cama_metas.key = 'enabled_languages'")
      .where("(#{CamaleonCms::Post.table_name}.published_at is not null and #{CamaleonCms::Post.table_name}.published_at <= ?)", Time.now)
      .where("visibility != 'private'")
      .where('cama_metas.value is null or cama_metas.value like ?', "%#{current_locale}%")
      .reorder(published_at: :desc)
      
      
    unless (keyword = params[:q]).blank?
      @title = "#{ct('search_msg', default: 'Text searched: ')} #{params[:q]}"
      @posts = @posts.where("LOWER(title) LIKE ? OR LOWER(content_filtered) LIKE ?", "%#{keyword.downcase}%", "%#{keyword.downcase}%")
    end
    if d = params[:p]
      @posts = @posts.where("#{CamaleonCms::Post.table_name}.published_at > ? ", d.to_i.days.ago.beginning_of_day)
    end
    if categories = params[:c]
      @category = current_site.the_full_categories.find(params[:c].first).decorate
      if @title.blank? && categories.size.eql?(1)
        @title = @category.name
      end
      @posts = @posts.joins(:categories).where('categories_cama_posts.id': categories.map{|c| c.to_i})
    end
    @posts_size = @posts.size
    @post_published_at_min = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.min
    @post_published_at_max = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.max
    @posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
    render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
  end
  
  def search_cp
    breadcrumb_add(ct("search"))
    #items = params[:post_type_slugs].present? ? current_site.the_posts(params[:post_type_slugs].split(',')) : current_site.the_posts
    @cama_visited_search = true
    #@param_search = params[:q]
    layout_ = lookup_context.template_exists?("layouts/search") ? "search" : nil
    r = {layout: layout_, render: "search", posts: nil}; hooks_run("on_render_search", r)
    #params[:q] = (params[:q] || '').downcase
    #@posts = current_site.posts.published
    @posts = current_site.the_posts('post').published
      .where("#{CamaleonCms::Post.table_name}.published_at <= ?", Time.now)
      .where("visibility != 'private'")
      .reorder(published_at: :desc)
    unless (keyword = params[:q]).blank?
      @title = "#{ct('search_msg', default: 'Text searched: ')} #{params[:q]}"
      @posts = @posts.where("LOWER(title) LIKE ? OR LOWER(content_filtered) LIKE ?", "%#{keyword.downcase}%", "%#{keyword.downcase}%")
    end
    if d = params[:p]
      @posts = @posts.where("#{CamaleonCms::Post.table_name}.published_at > ? ", d.to_i.days.ago.beginning_of_day)
    end
    if categories = params[:c]
      @category = current_site.the_full_categories.find(params[:c].first).decorate
      if @title.blank? && categories.size.eql?(1)
        @title = @category.name
      end
      @posts = @posts.joins(:categories).where('categories_cama_posts.id': categories.map{|c| c.to_i})
    end
    @posts_size = @posts.size
    @post_published_at_min = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.min
    @post_published_at_max = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.max
    @posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
    render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
  end
  
  # render category list
  def category
    
    logger.debug "*****"
    logger.debug "*** Category List ***" 
    logger.debug "*****"
    
    begin
      @category = current_site.the_full_categories.find(params[:category_id]).decorate
      @post_type = @category.the_post_type
    rescue
      return page_not_found
    end
    @cama_visited_category = @category
    @children = @category.children.no_empty.decorate
    @posts = @category.posts
      .published
      .joins("LEFT OUTER JOIN cama_metas cm ON cm.objectid = cama_posts.id AND cm.object_class = 'Post' AND cm.key = 'enabled_languages'")
      .where('cm.value is null or cm.value like ?', "%#{current_locale}%")
      .where("(#{CamaleonCms::Post.table_name}.published_at is null or #{CamaleonCms::Post.table_name}.published_at <= ?)", Time.now)
      .where("visibility != 'private'")
      .reorder(published_at: :desc)
      
    @posts_size = @posts.size
    @post_published_at_min = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.min
    @post_published_at_max = @posts.select{|_| _.published_at.present?}.collect{|_| _.published_at}.max
    @posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page).eager_load(:metas)
    
    respond_to do |format|
      
      format.html do
    
        r_file = lookup_context.template_exists?("category_#{@category.the_slug}") ? "category_#{@category.the_slug}" : nil  # specific template category with specific slug within a posttype
        r_file = lookup_context.template_exists?("post_types/#{@post_type.the_slug}/category") ? "post_types/#{@post_type.the_slug}/category" : nil unless r_file.present? # default template category for all categories within a posttype
        r_file = lookup_context.template_exists?("categories/#{@category.the_slug}") ? "categories/#{@category.the_slug}" : 'category' unless r_file.present?  # default template category for all categories for all posttypes

        layout_ = lookup_context.template_exists?("layouts/post_types/#{@post_type.the_slug}/category") ? "post_types/#{@post_type.the_slug}/category" : nil unless layout_.present? # layout for all categories within a posttype
        layout_ = lookup_context.template_exists?("layouts/categories/#{@category.the_slug}") ? "categories/#{@category.the_slug}" : nil unless layout_.present? # layout for categories for all post types
        r = {category: @category, layout: layout_, render: r_file}; hooks_run("on_render_category", r)
        render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
      end
      
      format.js 
      
    end
  end
end