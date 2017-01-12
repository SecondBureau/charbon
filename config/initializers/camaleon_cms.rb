CamaleonCms::FrontendController.class_eval do 
  def search_cp
    
    breadcrumb_add(ct("search"))
    #items = params[:post_type_slugs].present? ? current_site.the_posts(params[:post_type_slugs].split(',')) : current_site.the_posts
    @cama_visited_search = true
    #@param_search = params[:q]
    layout_ = lookup_context.template_exists?("layouts/search") ? "search" : nil
    r = {layout: layout_, render: "search", posts: nil}; hooks_run("on_render_search", r)
    #params[:q] = (params[:q] || '').downcase
    @posts = current_site.posts.published
      .where("#{CamaleonCms::Post.table_name}.published_at <= ?", Time.now)
      .where("visibility != 'private'")
      .reorder(published_at: :desc)
    unless (keyword = params[:q]).blank?
      @posts = @posts.where("LOWER(title) LIKE ? OR LOWER(content_filtered) LIKE ?", "%#{keyword.downcase}%", "%#{keyword.downcase}%")
    end
    if d = params[:published_after]
      @posts = @posts.where("#{CamaleonCms::Post.table_name}.published_at > ? ", d.to_i.days.ago.beginning_of_day)
    end
    if categories = params[:categories]
      @posts = @posts.joins(:categories).where('categories_cama_posts.id': categories.map{|c| c.to_i})
    end
    debugger
    @posts_size = @posts.size
    @posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
    render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
  end
end