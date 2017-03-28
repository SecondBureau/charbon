# theme = CamaleonCms::Theme.find_by_slug('china_india_dialogue')


module Themes::ChinaIndiaDialogue::MainHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
    klass.helper_method [:theme_image_tag, :nav_menu]
  end

  def china_india_dialogue_settings(theme)
    # here your code on save settings for current site, by default params[:theme_fields] is auto saved into theme
    # Also, you can save your extra values added in admin/settings.html.erb
    # sample: theme.set_meta("my_key", params[:my_value])
    #theme.set_field_values(params[:field_options])
  end

  # callback called after theme installed
  def china_india_dialogue_on_install_theme(theme)
    #unless theme.get_field_groups.where(slug: "fields").any?
      # group = theme.add_field_group({name: "Main Settings", slug: "fields", description: ""})
      # group.add_field({"name"=>"Background color", "slug"=>"bg_color"},{field_key: "colorpicker"})
      # group.add_field({"name"=>"Links color", "slug"=>"links_color"},{field_key: "colorpicker"})
      # group.add_field({"name"=>"Background image", "slug"=>"bg"},{field_key: "image"})
    #end
    
    unless theme.get_field_groups.where(slug: "issues").any? 
      last_issue_default_value = ''
      group = theme.add_field_group({name: "Issues", slug: "issues"})
      group.add_field({"name"=>"Last Issue", "slug"=>"last_issue"}, {field_key: "editor", translate: true, default_value: last_issue_default_value})
    end
  
    unless theme.get_field_groups.where(slug: "ads").any? 
      ad_left_default_value = ''
      ad_right_default_value = ''
      group = theme.add_field_group({name: "Ads", slug: "ads"})
      group.add_field({"name"=>"Left", "slug"=>"ad_left"}, {field_key: "editor", translate: true, default_value: ad_left_default_value})
      group.add_field({"name"=>"Right", "slug"=>"ad_right"}, {field_key: "editor", translate: true, default_value: ad_right_default_value})
    end

    unless theme.get_field_groups.where(slug: "partners").any? 
      partners_default_value = ''
      group = theme.add_field_group({name: "Partners", slug: "partners"})
      group.add_field({"name"=>"Partners", "slug"=>"partners"}, {field_key: "editor", translate: true, default_value: partners_default_value})
    end

    unless theme.get_field_groups.where(slug: "footer").any? 
      footer_default_value = ''
      group = theme.add_field_group({name: "Footer", slug: "footer"})
      group.add_field({"name"=>"Address", "slug"=>"address"}, {field_key: "editor", translate: true, default_value: footer_default_value})
    end
    
    unless theme.get_field_groups.where(slug: "social").any? 
      group = theme.add_field_group({name: "Social", slug: "social"})
      group.add_field({"name"=>"Facebook", "slug"=>"social_facebook"}, {field_key: "text_box", translate: true, default_value: ''})
      group.add_field({"name"=>"Twitter", "slug"=>"social_twitter"}, {field_key: "text_box", translate: true, default_value: ''})
      group.add_field({"name"=>"LinkedIn", "slug"=>"social_linkedin"}, {field_key: "text_box", translate: true, default_value: ''})
      group.add_field({"name"=>"WeChat", "slug"=>"social_wechat"}, {field_key: "file", translate: true, default_value: ''})
    end
    
    postType = CamaleonCms::PostType.find_by_slug('post')
    unless postType.get_field_groups.where(slug: 'customizations').any?
      group = postType.add_field_group({name: "Customizations", slug: "customizations"})
      group.add_field({"name"=>"Author", "slug"=>"author"}, {field_key: "text_box", translate: true, default_value: ''})
      group.add_field({"name"=>"Featured Image Caption", "slug"=>"fimage_caption"}, {field_key: "text_box", translate: true, default_value: ''})
      group.add_field({"name"=>"Responsive images class", "slug"=>"images_class"}, {field_key: "text_box", translate: true, default_value: 'img-responsive img-thumbnail'})
      group.add_field({"name"=>"Fixed width images class", "slug"=>"fixed_width_images_class"}, {field_key: "text_box", translate: true, default_value: 'pull-left inline-image img-thumbnail'})
    end
    
    ['Main Menu', "Footer 1", "Footer 2"].each do |item|
      slug = item.slugify.underscore
      instance_variable_set "@#{slug}", CamaleonCms::NavMenu.find_by_slug(slug)
      if instance_variable_get("@#{slug}").nil?
        instance_variable_set "@#{slug}", current_site.nav_menus.create!({name: item, slug: slug})
      end
    end
    
    category_parent = CamaleonCms::PostType.find_by_slug('post')
    unless category_parent.categories.count > 1 
      [{ slug: 'business',           label: 'Business',    footer1: true, navbar: true, class: 'home-block-border', show_featured_on_home: false },
       { slug: 'people',             label: 'People',      show_featured_on_home: true },
       { slug: 'culture',            label: 'Culture',     footer2: true, show_featured_on_home: false },
       { slug: 'society',            label: 'Society',     footer1: true, navbar: true, show_featured_on_home: true },
       { slug: 'ecology',            label: 'Ecology',     show_featured_on_home: true },
       { slug: 'exhibitions',        label: 'Exhibitions', show_featured_on_home: true },
       { slug: 'books',              label: 'Books',       navbar: true, show_featured_on_home: true },
       { slug: 'snapshots',          label: 'Snapshots',   show_featured_on_home: true },
       { slug: 'policy',             label: 'Policy',      footer1: true, class: 'home-block-reverse', show_featured_on_home: false },
       { slug: 'industry',           label: 'Industry',    footer1: true, navbar: true, show_featured_on_home: true },
       { slug: 'internet',           label: 'Internet',    footer1: true, navbar: true, show_featured_on_home: true },
       { slug: 'column',             label: 'Column',      show_featured_on_home: true },
       { slug: 'one-road-one-belt',  label: 'One Road One Belt', footer1: true, class: 'home-block-reverse', navbar: true, show_featured_on_home: false },
       { slug: 'environment',        label: 'Environment', additional_navbar:true, footer2: true, class: 'home-block-reverse', show_featured_on_home: true },
       { slug: 'travel-image',       label: 'Travel / Image', additional_navbar: true, footer2: true, show_featured_on_home: true },
       { slug: 'spotlight',          label: 'Spotlight',   footer1: true, navbar: true, show_featured_on_home: true }
      ].each do |c|
        category = CamaleonCms::Category.create(name: c[:label], slug: c[:label].slugify, parent_id: category_parent.id)
        category.set_option(:footer1, c[:footer1]) unless c[:footer1].blank?
        category.set_option(:footer2, c[:footer2]) unless c[:footer2].blank?
        category.set_option(:navbar, c[:navbar]) unless c[:navbar].blank?
        category.set_option(:class, c[:class]) unless c[:class].blank?
        category.set_option(:show_featured_on_home, c[:show_featured_on_home]) unless c[:show_featured_on_home].blank?
        unless c[:navbar].blank?
          @main_menu.append_menu_item ({label: category.name, type: "category", link: category.id})
        end
        unless c[:footer1].blank?
          @footer_1.append_menu_item ({label: category.name, type: "category", link: category.id})
        end
        unless c[:footer2].blank?
          @footer_2.append_menu_item ({label: category.name, type: "category", link: category.id})
        end
      end
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
    
    theme.set_meta("installed_at", Time.current.to_s) # save a custom value
  end

  # callback executed after theme uninstalled
  def china_india_dialogue_on_uninstall_theme(theme)
  end
  
  def theme_image_tag(source, options={})
    ActionController::Base.helpers.image_tag(theme_asset_path("images/#{source}"), options)
  end
  
  def nav_menu(options={})
    #options.merge!(callback_item: lambda{|args| args[:item_container_attrs] = "ui-sref-active='active'"; metas=args[:menu_item].get_meta('_default'); args[:link_attrs] = "ui-sref=\"#{metas[:type]}({slug: '\"CamaleonCms::#{metas[:type].capitalize}\".constantize.send(:find, metas[:object_id]).slug'})\" href"})
    
    l = lambda do |args|
      args[:item_container_attrs] = "ui-sref-active='active'"
      item = args[:menu_item]
      #metas = args[:menu_item].get_meta('_default')
      #slug = "CamaleonCms::#{metas[:type].capitalize}".constantize.send(:find, metas[:object_id]).slug
      #args[:link_attrs] = "ui-sref=\"#{metas[:type]}({slug: '#{slug}'})\" href"
      begin
        slug = "CamaleonCms::#{item.slug.capitalize}".constantize.send(:find, item.description.to_i).slug
        args[:link_attrs] = "ui-sref=\"#{item.slug}({slug: '#{slug}'})\" href"
      rescue
      end
    end
    
    options.merge!(callback_item: l)
    
    draw_menu(options).html_safe
  end
end
