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

	$("#s3_announcement_hd").S3Uploader
		progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#hd_upload_submit')
		remove_completed_progress_bar: false
	
	$("#s3_announcement_sd").S3Uploader
		progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#sd_upload_submit')
		remove_completed_progress_bar: false
	
	$("#s3_intro_video_hd").S3Uploader
	  progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#hd_upload_submit')
		remove_completed_progress_bar: false
	
	$("#s3_intro_video_sd").S3Uploader
	  progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $('#sd_upload_submit')
		remove_completed_progress_bar: false
	
	$("#s3_expert_intro_video_hd").S3Uploader
	  progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $("#hd_upload_submit")
		remove_completed_progress_bar: false
	
	$("#s3_expert_intro_video_sd").S3Uploader
	  progress_bar_target: $('.js-progress-bars')
		allow_multiple_files: false
		click_submit_target: $("#sd_upload_submit")
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
	
	$("#s3_announcement_hd").bind "s3_upload_complete", (e, content) ->
		$("#announcement_hd_url").val(content.url)
		$("#announcement_attached_video_hd_file_name").val(content.filename)
		$("#announcement_attached_video_hd_content_type").val(content.filetype)
		$("#announcement_attached_video_hd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")

	$("#s3_announcement_sd").bind "s3_upload_complete", (e, content) ->
		$("#announcement_sd_url").val(content.url)
		$("#announcement_attached_video_sd_file_name").val(content.filename)
		$("#announcement_attached_video_sd_content_type").val(content.filetype)
		$("#announcement_attached_video_sd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")
	
	$("#s3_intro_video_hd").bind "s3_upload_complete", (e, content) ->
		$("#course_intro_video_attributes_hd_url").val(content.url)
		$("#course_intro_video_attributes_attached_video_hd_file_name").val(content.filename)
		$("#course_intro_video_attributes_attached_video_hd_content_type").val(content.filetype)
		$("#course_intro_video_attributes_attached_video_hd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")
	
	$("#s3_intro_video_sd").bind "s3_upload_complete", (e, content) ->
		$("#course_intro_video_attributes_sd_url").val(content.url)
		$("#course_intro_video_attributes_attached_video_sd_file_name").val(content.filename)
		$("#course_intro_video_attributes_attached_video_sd_content_type").val(content.filetype)
		$("#course_intro_video_attributes_attached_video_sd_file_size").val(content.filesize)
		$(e.target).find(".bars").text("completed uploading")
	
	$("#s3_expert_intro_video_hd").bind "s3_upload_complete", (e, content) ->
		$("#expert_intro_video_attributes_attached_video_hd_file_name").val(content.filename)
		$("#expert_intro_video_attributes_attached_video_hd_content_type").val(content.filetype)
		$("#expert_intro_video_attributes_attached_video_hd_file_size").val(content.filesize)
		$("#expert_intro_video_attributes_hd_url").val(content.url)
		$(e.target).find(".bars").text("completed uploading")

	$("#s3_expert_intro_video_sd").bind "s3_upload_complete", (e, content) ->
		$("#expert_intro_video_attributes_attached_video_sd_file_name").val(content.filename)
		$("#expert_intro_video_attributes_attached_video_sd_content_type").val(content.filetype)
		$("#expert_intro_video_attributes_attached_video_sd_file_size").val(content.filesize)
		$("#expert_intro_video_attributes_sd_url").val(content.url)
		$(e.target).find(".bars").text("completed uploading")

upload_failed = ->
	$("#s3_video_interview_hd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_video_interview_sd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_announcement_hd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_announcement_sd").bind "s3_upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_expert_intro_video_hd").bind "upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"
	$("#s3_expert_intro_video_sd").bind "upload_failed", (e, content) ->
		$(e.target).find(".bars").text "upload failed"

$(document).ready s3_upload
$(document).on 'page:load', s3_upload

$(document).ready s3_complete
$(document).on 'page:load', s3_complete

$(document).ready upload_failed
$(document).on 'page:load', upload_failed

$(document).on "s3_uploads_start", (e) ->
	$(e.target).find(".bars").text("uploading")

$(document).on "ajax:success", ->
	s3_upload()
	s3_complete()
	upload_failed()
