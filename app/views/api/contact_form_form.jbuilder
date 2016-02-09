json.theme_slug @theme.try(:slug)
json.form do
  json.fields @form_fields
  json.submit @form_submit
end
json.messages do
  json.submitted @flash_message_submitted
  json.error     @flash_message_error
end
