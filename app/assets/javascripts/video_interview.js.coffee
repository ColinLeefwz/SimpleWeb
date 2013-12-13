s3_upload = ->
	$("#s3_video_interview_hd").S3Uploader
		progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#hd_upload_submit')
		remove_completed_progress_bar: false
	
	$("#s3_video_interview_sd").S3Uploader
		progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#sd_upload_submit')
		remove_completed_progress_bar: false

s3_complete = ->
	$("#s3_video_interview_hd").bind "s3_upload_complete", (e, content) ->
		$("#video_interview_hd_url").val(content.url)
		$("#video_interview_attached_video_hd_file_name").val(content.filename)
		$("#video_interview_attached_video_hd_content_type").val(content.filetype)
		$("#video_interview_attached_video_hd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")

	$("#s3_video_interview_sd").bind "s3_upload_complete", (e, content) ->
		$("#video_interview_sd_url").val(content.url)
		$("#video_interview_attached_video_sd_file_name").val(content.filename)
		$("#video_interview_attached_video_sd_content_type").val(content.filetype)
		$("#video_interview_attached_video_sd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")

upload_failed = ->
	$("#s3_video_interview_hd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_video_interview_sd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"

$(document).ready s3_upload
$(document).on 'page:load', s3_upload

$(document).ready s3_complete
$(document).on 'page:load', s3_complete

$(document).ready upload_failed
$(document).on 'page:load', upload_failed

$(document).on "s3_uploads_start", (e) ->
	$(e.target).find(".bars").text("uploading")
