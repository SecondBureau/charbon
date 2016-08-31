

namespace :db do
  desc "Maintenance media"
  task :update_media_url, [:old, :new] => :environment do |t, args|
    old_root = args[:old]
    new_root = args[:new]
    
    puts "### PROCESSING Posts ...."
    tot = CamaleonCms::Post.count
    
    CamaleonCms::Post.all.each_with_index do |post, index|
      puts "processing row #{index}/#{tot}"
      post.content = post.content.gsub(old_root, new_root)
      post.save!
    end
    
    puts "### done \n\n"
    
    puts "### PROCESSING featured images ...."
    collection = CamaleonCms::Meta.where(key: 'thumb')
    tot = collection.count
    collection.each_with_index do |meta, index|
      puts "processing row #{index}/#{tot}"
      meta.value = meta.value.gsub(old_root, new_root)
      meta.save!
    end
    
    puts "### done \n\n"
    
  end

  desc "TODO"
  task seed_posts: :environment do
  end

end