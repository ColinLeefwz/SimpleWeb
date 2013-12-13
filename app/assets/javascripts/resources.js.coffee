
do_on_load = ->
  $(".s3_uploader").S3Uploader
    allow_multiple_files: false

$(document).ready(do_on_load)
$(document).on 'page:load', do_on_load




$(document).on "s3_uploads_start", (e) ->
  $(e.target).find(".status").first().text("uploading...")

$(document).on "s3_upload_complete", (e, content) ->
  definition = $(e.target).data("definition")
  resource_field = $("."+definition)
  resource_field.find("[id$=video_definition]").first().val(definition)
  resource_field.find("[id$=direct_upload_url]").first().val(content.url)
  resource_field.find("[id$=attached_file_file_name]").first().val(content.filename)
  resource_field.find("[id$=attached_file_file_size]").first().val(content.filesize)
  resource_field.find("[id$=attached_file_content_type]").first().val(content.filetype)
  resource_field.find("[id$=attached_file_file_path]").first().val(content.filepath)
  $(e.target).find(".status").first().text("success!")

$(document).on "s3_upload_failed", (e, content) ->
  alert("#{content.filename} failed to upload: #{content.error_thrown}")


$(document).on "click", ".section-save", ->
  $(".edit_section").submit()
