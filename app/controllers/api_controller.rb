class ApiController < ApplicationController
  
  prepend_view_path Rails.root.join("app/apps/").to_s
  
  def cp_posts_blocks_thumbnails
    post = CamaleonCms::Post.find(params[:post_id].to_i)
    if post.nil?
      @posts = CamaleonCms::Post.all.to_a.sample(3)
    else
      @posts = post.decorate.the_related_posts.where('cama_posts.id != ?', post.id).to_a.sample(3)
    end
  end
  

end