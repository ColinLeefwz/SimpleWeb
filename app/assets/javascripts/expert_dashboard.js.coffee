side_bar = ->
	$(".item-text > a").on 'click', ->
		$(".item").find(".item-icon").css("display", "inline-block")
		$(this).parents(".item").find(".item-icon").css("display", "none")
		$(".item").find(".item-icon-selected").css("display", "none")
		$(this).parents(".item").find(".item-icon-selected").css("display", "inline-block")
		$(".item").find(".item-text > a").css("color", "")
		$(this).parents(".item").find(".item-text > a").css("color", "#880848")

## Original one, clear the form
# cancel = ->
# 	$(".cancel").on 'click', ->
# 		$(this).closest("form")[0].reset()
# 		$.each CKEDITOR.instances, (index, instance) ->
# 			instance.setData("")

class AjaxEffect
	constructor: ->
	
	start: ->
		@create_new_session_date()
		# @session_preview()

	create_new_session_date: ->
		currentdate = new Date()
		$('#datepicker').datetimepicker({
			maskInput: true,
			startDate: currentdate,
			pickTime: false
		})

		$('#starttimepicker').datetimepicker({
			maskInput: true,
			pickDate: false,
			pickSeconds: false,
			pick12HourFormat: true
		})

		$('#endtimepicker').datetimepicker({
			maskInput: true,
			pickDate: false,
			pickSeconds: false,
			pick12HourFormat: true
		})


$(document).ready ->
  side_bar()

$(document).on 'page:load', ->
  side_bar()

$(document).on 'ajax:success', ->
	(new AjaxEffect).start()
