@results.each do |category_id, posts|
  json.array! posts do |post|
    json.id post.id
    json.category_id category_id
    json.slug post.slug
    json.title post.decorate.the_title
    json.featured_image_url post.get_meta("thumb")
    json.author_id post.user_id
    json.published_at post.published_at
    json.post_type 'post'
    unless (dimensions = post.get_meta("thumb_dimensions")).nil?
      width, height = dimensions.split("x")
      json.image_width width.to_i
      json.image_height height.to_i
    else
      json.image_width @default_width
      json.image_height @default_height
    end
    json.summary post.get_meta("summary")
    json.body post.content
    post.field_values.each do |fv|
      json.set! fv.custom_field_slug, fv.value
    end
  end
end