GrapeSwaggerRails.options.before_filter_proc = proc {
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port + '/api/v1'
}
GrapeSwaggerRails.options.app_name = 'Lizard'