class ApiController < ApplicationController
  
  prepend_view_path Rails.root.join("app/apps/").to_s
  
  def cp_posts_blocks_thumbnails
    @post = CamaleonCms::Post.find(params[:post_id].to_i)
    return render html: "<b>Reload Page</b>".html_safe if @post.nil?
    
  end
  

end