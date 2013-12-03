
do_on_load = ->
  $("#s3_uploader").S3Uploader
    allow_multiple_files: false

  $("#s3_uploader").on "s3_uploads_start", (e) ->
    $(".status").html("uploading.......")

  $("#s3_uploader").on "s3_upload_failed", (e, content) ->
    console.log(content.error_thrown)
    alert("#{content.filename} failed to upload: #{content.error_thrown}")


  $("#s3_uploader").on "s3_upload_complete", (e,content) ->
    $(".status").html("success!")
    $("#resource-submit").attr(disabled: false)
    $("#resource_direct_upload_url").val(content.url)
    $("#resource_attached_file_file_name").val(content.filename)
    $("#resource_attached_file_file_path").val(content.filepath)
    $("#resource_attached_file_file_size").val(content.filesize)
    $("#resource_attached_file_content_type").val(content.filetype)
    console.log(content.filetype)
    console.log(content.filesize)
    alert("success")

$(document).ready(do_on_load)
$(document).on 'page:load', do_on_load
