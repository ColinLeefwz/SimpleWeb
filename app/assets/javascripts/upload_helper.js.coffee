@upload_helper = ->
  $(".s3_uploader").S3Uploader
    allow_multiple_files: false

  $(document).on "s3_uploads_start", (e) ->
    $(e.target).find(".status").text("uploading...")

  $(document).on "s3_upload_complete", (e, content) ->
    definition = $(e.target).data("definition")
    resource_field = $("."+definition)

    resource_field.find("[id$=file_name]").val(content.filename)
    resource_field.find("[id$=file_size]").val(content.filesize)
    resource_field.find("[id$=content_type]").first().val(content.filetype)
    resource_field.find("[id$=temp_path]").val(content.filepath)
    $(e.target).find(".status").text("success!")

  $(document).on "s3_upload_failed", (e, content) ->
    alert("#{content.filename} failed to upload: #{content.error_thrown}")

  $("#destroy_SD").on "click", ->
    destroy_SD = if $("#destroy_SD:checked").length then true else false
    $("[id$=_destroy_SD]").val(destroy_SD)

  $("#destroy_HD").on "click", ->
    destroy_HD = if $("#destroy_HD:checked").length then true else false
    $("[id$=_destroy_HD]").val(destroy_HD)
