# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'json'
#
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

class TmpUpload
  include CamaleonCms::UploaderHelper
  include CamaleonCms::HooksHelper
  include Rails.application.routes.url_helpers
  
  def initialize(current_site, current_theme)
    @current_site = current_site
    @current_theme = current_theme
  end
  
  def current_site
    @current_site
  end
  
  def current_theme
    @current_theme
  end
  
  def upload_image(url, folder)
    print ".."
    uri = URI.parse(url)
    io = uri.open
    content_type = io.content_type
    file = ActionDispatch::Http::UploadedFile.new(tempfile: io, filename: File.basename(url), content_type: content_type)
    upload_file(file, {folder: "//#{folder}"})
  end
  
  def upload(filename, folder)
    http_base = 'https://s3-ap-northeast-1.amazonaws.com/china-india-dialogue'
    image_url = "#{http_base}/#{filename}"
    #puts "uploading #{image_url}..." 
    upload_image(image_url, folder)
  end
  
  def url(filename, folder)
    tree = cama_media_find_folder("/#{folder}")
    tree[:files].each do |f|
      return f['url'] if f['name'].eql?(filename)
    end
    return ''
  end
end


CamaleonCms::Post.where('id > 2').destroy_all
CamaleonCms::User.where('id > 1').destroy_all

category_parent_id = CamaleonCms::PostType.find_by_slug('post').id
post_term_taxonomy_id = CamaleonCms::TermTaxonomy.find_by_slug('post').id

site = CamaleonCms::Site.first
site.categories.destroy_all

theme = CamaleonCms::Theme.find_by_slug('china_india_dialogue')

media = TmpUpload.new(site, theme)

themes = {
  '0' => 'business',
  '1' => 'people',
  '2' => 'cats',
  '3' => 'city',
  '4' => 'nature',
  '5' => 'abstract',
  '6' => 'fashion',
  '7' => 'abstract',
  '8' => 'business',
  '9' => 'technics',
  '10' => 'nightlife',
  '11' => 'people',
  '12' => 'abstract',
  '13' => 'nature',
  '14' => 'sports',
  '20' => 'abstract'
}

print "Seed columnist avatars..."

avatars_folder = "avatars"
uri = "http://uifaces.com/api/v1/random"
avatars = []
(1..5).each do |i|
  media.upload_image(JSON.parse(Net::HTTP.get(URI(uri)))["image_urls"]["epic"], avatars_folder)
  print ".."
end

(1..4).each do |i|
  media.upload("columnist-#{i}.png", avatars_folder)
  #avatars << media.url("columnist-#{i}.png", avatars_folder)
  print ".."
end

tree = media.cama_media_find_folder("/#{avatars_folder}")
tree[:files].each do |p|
  avatars << p['url']
end

puts "done !"

print "Seed users..."

10.times do
  
  print ".."

  firstname = Faker::Name.first_name
  lastname  = Faker::Name.last_name
  twitter = "#{firstname.downcase}_#{lastname.downcase}"
  role = 'client'
  email   = "#{firstname.downcase}.#{lastname.downcase}@local.net"
  password = 'secret'

  u = CamaleonCms::User.create(username: "#{firstname.downcase}#{lastname.downcase}", role: role, email: email, password: password, password_confirmation:password)

  u.set_meta_from_form({first_name: firstname, last_name: lastname, twitter: twitter})

  avatar = avatars[rand(4)]
  u.set_meta 'avatar', avatar

end

puts "done !"

userids = CamaleonCms::User.where('id > 1').collect{|u| u.id}

## Menu
print "Seed menu..."

['Main Menu', "Footer 1", "Footer 2"].each do |item|
  slug = item.slugify.underscore
  instance_variable_set "@#{slug}", CamaleonCms::NavMenu.find_by_slug(slug)
  if instance_variable_get("@#{slug}").nil?
    instance_variable_set "@#{slug}", site.nav_menus.create!({name: item, slug: slug})
  else
    instance_variable_get("@#{slug}").children.try(:destroy_all)
  end
end

puts "done !"


print "Seed posts..."
[
    { id: 0, order: 2, slug: 'business', label: 'Business', footer1: true, navbar: true, class: 'home-block-border', show_featured_on_home: false },
    { id: 1, order: 99, slug: 'people', label: 'People', show_featured_on_home: true },
    { id: 2, order: 99, slug: 'culture', label: 'Culture', footer2: true, show_featured_on_home: false },
    { id: 3, order: 6, slug: 'society', label: 'Society', footer1: true, navbar: true, show_featured_on_home: true },
    { id: 4, order: 99, slug: 'ecology', label: 'Ecology', show_featured_on_home: true },
    { id: 5, order: 99, slug: 'exhibitions', label: 'Exhibitions', show_featured_on_home: true },
    { id: 6, order: 99, slug: 'books', label: 'Books', navbar: true, show_featured_on_home: true },
    { id: 7, order: 99, slug: 'snapshots', label: 'Snapshots', show_featured_on_home: true },
    { id: 8, order: 3, slug: 'policy', label: 'Policy', footer1: true, class: 'home-block-reverse', show_featured_on_home: false },
    { id: 9, order: 4, slug: 'industry', label: 'Industry', footer1: true, navbar: true, show_featured_on_home: true },
    { id: 10, order: 5, slug: 'internet', label: 'Internet', footer1: true, navbar: true, show_featured_on_home: true },
    { id: 11, order: 99, slug: 'column', label: 'Column', show_featured_on_home: true },
    { id: 12, order: 7, slug: 'one-road-one-belt', label: 'One Road One Belt', footer1: true, class: 'home-block-reverse', navbar: true, show_featured_on_home: false },
    { id: 13, order: 99, slug: 'environment', label: 'Environment', additional_navbar:true, footer2: true, class: 'home-block-reverse', show_featured_on_home: true },
    { id: 14, order: 99, slug: 'travel-image', label: 'Travel / Image', additional_navbar: true, footer2: true, show_featured_on_home: true },
    { id: 20, order: 1, slug: 'spotlight', label: 'Spotlight', footer1: true, navbar: true, show_featured_on_home: true }
  ].each do |c|

    print "*"

    if (category = CamaleonCms::Category.find_by_slug(c[:label].slugify)).nil?
      category = CamaleonCms::Category.create(name: c[:label], slug: c[:label].slugify, parent_id: category_parent_id)
    end
    # if (meta = CamaleonCms::Meta.find_by_key("_#{category.slug}")).nil?
 #      meta = CamaleonCms::Meta.new(key: "_#{category.slug}", objectid: category.id, object_class: "Category")
 #    end
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

    (rand(15) + 5).times do

      title = Faker::Hipster.sentence(1)

      #puts "create post #{title}"
      print "."

      if category.slug.eql?('travel-image') || category.slug.eql?('spotlight')
        width=800
        height=420
      else
        width = rand(300)+1000
        height = rand(600)+300
      end

      #puts

      url = "http://lorempixel.com/#{width}/#{height}/#{themes[c[:id].to_s]}/China-India-Dialogue/?#{rand(10000)}"


      content = ""
      (1..rand(5)+5).each do |i|
        level = rand(3)+1
        content += "<h#{level}>#{Faker::Lorem.sentence(3)}</h#{level}>"
        (1..rand(5)+1).each do |j|
          content += "<p>#{Faker::Hipster.paragraph(rand(4) + 5)}</p>"
        end
      end

      post_data = {
        title:title,
        slug:title.slugify,
        content:content ,
        published_at:"#{Faker::Date.backward(30)}",
        user_id: userids.shuffle.first,
        data_categories: [category.id]
      }

      #p = CamaleonCms::Post.new()

      p = CamaleonCms::Site.first.post_types.find_by_slug('post').decorate.posts.create(post_data)

      #p.save!

      #puts "saved"
      #puts p.inspect


      p.set_thumb url
      p.set_meta 'thumb_dimensions', "#{width}x#{height}"
      p.set_summary Faker::Hipster.paragraph(4)

      # if (meta = CamaleonCms::Meta.find_by_key("_#{p.slug}")).nil?
      #   meta = CamaleonCms::Meta.new(key: "_#{p.slug}", objectid: p.id, object_class: "Post")
      # end

    end

end

puts "done !"
#
# # Themes


print "Seed partners..."

partners_folder = "partners"

(1..16).each do |i|
  media.upload("partner-#{i}.png", partners_folder)
end

tree = media.cama_media_find_folder("/#{partners_folder}")
partners_default_value = ""
tree[:files].each do |p|
  partners_default_value += "<a href='#'><img class='logo-partner' alt='Partner' src='#{p['url']}' /></a>"
end

puts "done !"



print "Seed ads..."

ads_folder = "ads"

(1..2).each do |i|
  media.upload("ad#{i}.png", ads_folder)
end

ad_left_default_value = "<a href='#'><img class='' alt='Ad' src='#{media.url('ad2.png', ads_folder)}' /></a>"
ad_right_default_value = "<a href='#'><img class='' alt='Ad' src='#{media.url('ad1.png', ads_folder)}' /></a>"

puts "done !"



print "Seed issues..."

issues_folder = "issues"
media.upload("issue.png", issues_folder)
last_issue_default_value = "<a href='#'><img class='' alt='Latest Issue' src='#{media.url('issue.png', issues_folder)}' /></a>"

puts "done!"


print "Seed field_groups..."

unless theme.nil?
  theme.get_field_groups.destroy_all
  
  group = theme.add_field_group({name: "Issues", slug: "issues"})
  group.add_field({"name"=>"Last Issue", "slug"=>"last_issue"}, {field_key: "editor", translate: true, default_value: last_issue_default_value})
  
  group = theme.add_field_group({name: "Ads", slug: "ads"})
  group.add_field({"name"=>"Left", "slug"=>"ad_left"}, {field_key: "editor", translate: true, default_value: ad_left_default_value})
  group.add_field({"name"=>"Right", "slug"=>"ad_right"}, {field_key: "editor", translate: true, default_value: ad_right_default_value})

  group = theme.add_field_group({name: "Partners", slug: "partners"})
  group.add_field({"name"=>"Partners", "slug"=>"partners"}, {field_key: "editor", translate: true, default_value: partners_default_value})

  group = theme.add_field_group({name: "Footer", slug: "footer"})
  group.add_field({"name"=>"Address", "slug"=>"address"}, {field_key: "editor", translate: true, default_value: "<p><b>Address:</b><br/>33 Chegongzhuang Xilu,<br/>Beijing, 100048, P.R. China</p><p><b>Telephone:</b><br/>+8610 8841 7455</p><p><b>Email:</b> contact@chinapictorial.com.cn</p>"})
end

puts "done !"
