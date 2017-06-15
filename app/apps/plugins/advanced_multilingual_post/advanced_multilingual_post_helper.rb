module Plugins::AdvancedMultilingualPost::AdvancedMultilingualPostHelper
  
  def plugin_advanced_multilingual_post_on_active(plugin)
  end
  
  def plugin_advanced_multilingual_post_on_inactive(plugin)
  end
  
  def plugin_advanced_multilingual_post_list(args)
  end
   
  def plugin_advanced_multilingual_new_post(args)
    args[:extra_settings] << plugin_advanced_multilingual_post_form_html(args[:post])
  end
  
  def plugin_advanced_multilingual_create_post(args)
  end
  
  def plugin_advanced_multilingual_post_the_content(args)
  end

  def plugin_advanced_multilingual_filter_post(args)
  end

  def plugin_advanced_multilingual_can_visit(args)
  end

  def plugin_advanced_multilingual_extra_columns(args)
  end


  private

  def plugin_advanced_multilingual_post_form_html(post)
    "
    <div class='form-group list-categories'>
      <label class='control-label'>#{t(:languages, scope: :plugin_advanced_multilingual_post)}</label>
      <ul class='categorychecklist'>
      #{plugin_advanced_multilingual_post_list(post)}
      </ul>
    </div>
    "
  end
  

  
  def plugin_advanced_multilingual_post_list(post)
    ret = ''
    current_site.object.get_languages.each do |lang|
      checked = (post.get_meta('enabled_languages').present? && post.get_meta('enabled_languages').include?(lang.to_s)) ? 'checked="checked"' : ''
      ret += "<li><label><input type='checkbox' value='#{lang.to_s}' #{checked} name='meta[enabled_languages][]'>#{t(lang.to_s, scope: :languages)}</label></li>"
    end
    ret
  end

end
