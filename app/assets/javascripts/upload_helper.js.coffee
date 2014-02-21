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
    resource_field.find("[id$=file_path]").val(content.filepath)
    $(e.target).find(".status").text("success!")

  $(document).on "s3_upload_failed", (e, content) ->
    alert("#{content.filename} failed to upload: #{content.error_thrown}")
