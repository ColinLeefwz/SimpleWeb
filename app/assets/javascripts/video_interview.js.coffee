s3_upload = ->
	$("#s3_video_interview_hd").S3Uploader
	  path: 'video_interviews/hd/'
		progress_bar_target: $(".js-progress-bars")
	$("#s3_video_interview_sd").S3Uploader
	  path: 'video_interviews/sd/'
		progress_bar_target: $(".js-progress-bars")


$(document).ready s3_upload
$(document).on 'page:load', s3_upload

$(document).on "s3_uploads_start", (e) ->
	alert "uploading"
$(document).on "s3_upload_complete", (e, content) ->
	alert "complete"
