json.array! @categories do |category|
  #category.metas.first.value if category.metas.first
  json.id           category.id
  json.description  category.description
  json.label        category.name
  json.slug         category.slug
  category.options.each do |key, value|
    json.set! key, value
  end
end