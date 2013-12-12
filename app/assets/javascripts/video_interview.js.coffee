s3_upload = ->
	$("#s3_video_interview_hd").S3Uploader
	  path: 'video_interviews/hd/'
		progress_bar_target: $(".js-progress-bars")
	$("#s3_video_interview_sd").S3Uploader
	  path: 'video_interviews/sd/'
		progress_bar_target: $(".js-progress-bars")

s3_complete = ->
	$("#s3_video_interview_hd").bind "s3_upload_complete", (e, content) ->
		$("#video_interview_hd_url").val(content.url)
		$("#video_interview_attached_video_hd_file_name").val(content.filename)
		$("#video_interview_attached_video_hd_content_type").val(content.filetype)
		$("#video_interview_attached_video_hd_file_size").val(content.filesize)
		alert "hd file upload complete"

	$("#s3_video_interview_sd").bind "s3_upload_complete", (e, content) ->
		$("#video_interview_sd_url").val(content.url)
		$("#video_interview_attached_video_sd_file_name").val(content.filename)
		$("#video_interview_attached_video_sd_content_type").val(content.filetype)
		$("#video_interview_attached_video_sd_file_size").val(content.filesize)
		alert "sd file uploaded"

$(document).ready s3_upload
$(document).on 'page:load', s3_upload

$(document).ready s3_complete
$(document).on 'page:load', s3_complete


$(document).on "s3_uploads_start", (e) ->
	alert "start uploading"

