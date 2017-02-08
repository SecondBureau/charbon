module Themes::ChinaPictorial::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  def china_pictorial_settings(theme)
    # callback to save custom values of fields added in my_theme/views/admin/settings.html.erb
  end

  # callback called after theme installed
  def china_pictorial_on_install_theme(theme)
    # # Sample Custom Field
    # unless theme.get_field_groups.where(slug: "fields").any?
    #   group = theme.add_field_group({name: "Main Settings", slug: "fields", description: ""})
    #   group.add_field({"name"=>"Background color", "slug"=>"bg_color"},{field_key: "colorpicker"})
    #   group.add_field({"name"=>"Links color", "slug"=>"links_color"},{field_key: "colorpicker"})
    #   group.add_field({"name"=>"Background image", "slug"=>"bg"},{field_key: "image"})
    # end
    
    unless theme.get_field_groups.where(slug: "ads").any? 
      group = theme.add_field_group({name: "Ads", slug: "ads", description: "Advertissements on Home Page"})
      group.add_field({"name"=>"ad horizontal image", "slug"=>"ad1-img"}, {required: true, field_key: "file", formats: 'image', translate: false, default_value: nil})
      group.add_field({"name"=>"ad horizontal link", "slug"=>"ad1-link_to"}, {required: false, field_key: "url", translate: false, default_value: nil})
      group.add_field({"name"=>"ad vertical image", "slug"=>"ad2-img"}, {required: true, field_key: "file", formats: 'image', translate: false, default_value: nil})
      group.add_field({"name"=>"ad vertical link", "slug"=>"ad2-link_to"}, {required: false, field_key: "url", translate: false, default_value: nil})
    end
    
    unless theme.get_field_groups.where(slug: "footer").any? 
      group = theme.add_field_group({name: "Footer", slug: "footer"})
      group.add_field({"name"=>"SEO", "slug"=>"footer_seo"}, {field_key: "editor", translate: true, default_value: ''})
      group.add_field({"name"=>"Address", "slug"=>"footer_address"}, {field_key: "editor", translate: true, default_value: ''})
    end
    
    unless theme.get_field_groups.where(slug: "social").any? 
      group = theme.add_field_group({name: "Social", slug: "social"})
      group.add_field({"name"=>"Facebook", "slug"=>"social_facebook"}, {field_key: "text_box", translate: false, default_value: ''})
      group.add_field({"name"=>"Twitter", "slug"=>"social_twitter"}, {field_key: "text_box", translate: false, default_value: ''})
      group.add_field({"name"=>"LinkedIn", "slug"=>"social_linkedin"}, {field_key: "text_box", translate: false, default_value: ''})
      group.add_field({"name"=>"WeChat", "slug"=>"social_wechat"}, {field_key: "file", translate: false, default_value: ''})
    end
    
    {xs: 'Extra small devices', sm: 'Small devices', md: 'Medium devices', lg: 'Large devices', xl: 'Extra large devices'}.each do |size, name|
      slug = "menu_#{size.to_s}"
      menu = CamaleonCms::NavMenu.find_by_slug(slug)
      if menu.nil?
        menu = current_site.nav_menus.create!({name: "Main Menu (#{name})", slug: slug})
        categories = CamaleonCms::PostType.find_by_slug('post').categories.to_a
        category = categories.shift
        menu.append_menu_item ({label: category.name, type: "category", link: category.id})
        dropdown = menu.append_menu_item ({label: '☰', type: "external", link: 'root_url'})
        categories.each do |category|
          dropdown.append_menu_item ({label: category.name, type: "category", link: category.id})
        end
      end
    end
    
    postType = CamaleonCms::PostType.find_by_slug('post')
    unless postType.get_field_groups.where(slug: 'options').any?
      group = postType.add_field_group({name: "Options", slug: "options", is_repeat: 0})
      group.add_field({"name"=>"By", "slug"=>"author_by"}, {
          field_key: "select", 
          translate: false, 
          multiple_options: [
            {title: "Text by", value: 1, default: 1}, 
            {title: "Edited by", value: 2},
            {title: "Published by", value: 3},
            {title: "Text and Photographs by", value: 4}]})
      
      group.add_field({"name"=>"Author/Editor/Photograph", "slug"=>"author"}, {field_key: "text_box", translate: true, default_value: ''})
      
      group.add_field({"name"=>"Featured Image Caption", "slug"=>"fimage_caption"}, {field_key: "text_box", translate: true, default_value: ''})
      
      #group.add_field({"name"=>"Responsive images class", "slug"=>"images_class"}, {field_key: "text_box", translate: true, default_value: 'img-responsive img-thumbnail'})
      #group.add_field({"name"=>"Fixed width images class", "slug"=>"fixed_width_images_class"}, {field_key: "text_box", translate: true, default_value: 'pull-left inline-image img-thumbnail'})
    end
    
    slug = "carousel_posts"
    menu = CamaleonCms::NavMenu.find_by_slug(slug)
    if menu.nil?
      menu = current_site.nav_menus.create!({name: "Slider Posts", slug: slug})
      CamaleonCms::PostType.find_by_slug('post').posts.limit(4).each do |post|
        menu.append_menu_item ({label: post.title, type: "post", link: post.id})
      end
    end
    
    
    slug = 'issue'
    postType = current_site.post_types.find_by_slug(slug)
    params = {
      name: "Issue",
      slug: slug, 
      description: 'Paper Issue',
      data_options: {icon: "book", 
                    has_layout: false,
                    default_layout: "",
                    has_template: true,
                    default_template: "",
                    has_category: false,
                    has_tags: false,
                    has_content: false,
                    has_summary: false,
                    has_comments: false,
                    has_featured: false,
                    has_seo: false,
                    has_parent_structure: false, 
                    has_picture: true, 
                    posts_image_dimension: "", 
                    posts_thumb_versions: "",
                    posts_thumb_size: "140x180", 
                    is_required_picture: true, 
                    contents_route_format: "post",
                    default_thumb: ""}}
    if postType.nil?
      postType = current_site.post_types.create(params)
    end
    
    slug = 'Document'
    unless postType.get_field_groups.where(slug: slug).any?
      group = postType.add_field_group({name: "Document", slug: slug})
      group.add_field({"name"=>"PDF", "slug"=>"pdf_file"}, {field_key: "file", translate: false, default_value: ''})
    end
    

    # # Sample Meta Value
    # theme.set_meta("installed_at", Time.current.to_s) # save a custom value
  end

  # callback executed after theme uninstalled
  def china_pictorial_on_uninstall_theme(theme)
  end
  
  def theme_image_tag(source, options={})
    ActionController::Base.helpers.image_tag(theme_asset_path("images/#{source}"), options)
  end
end
