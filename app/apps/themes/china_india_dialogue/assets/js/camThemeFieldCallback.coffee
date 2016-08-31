window.camThemeFieldCallback = (themeSlug, fieldSlug) ->
  if (themeSlug=='china_india_dialogue' && fieldSlug=='last_issue')
    $("cam-theme-field[slug='last_issue'] img").removeAttr('width').removeAttr('height').addClass('img-responsive')