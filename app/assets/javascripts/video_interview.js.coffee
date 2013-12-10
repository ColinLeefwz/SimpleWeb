s3_upload = ->
	$("#s3_video_interview").S3Uploader()

$(document).ready s3_upload
$(document).on 'page:load', s3_upload

$(document).on "s3_uploads_start", (e) ->
	alert "uploading"
$(document).on "s3_upload_complete", (e, content) ->
	alert "complete"
