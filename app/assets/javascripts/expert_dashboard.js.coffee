side_bar = ->
	$(".item-text > a").on 'click', ->
		$(".item").find(".item-icon").css("display", "inline-block")
		$(this).parents(".item").find(".item-icon").css("display", "none")
		$(".item").find(".item-icon-selected").css("display", "none")
		$(this).parents(".item").find(".item-icon-selected").css("display", "inline-block")
		$(".item").find(".item-text > a").css("color", "")
		$(this).parents(".item").find(".item-text > a").css("color", "#880848")

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
  $("[data-validate]").blur ->
    $.ajax
      type: 'POST'
      url:  '/users/validate_user_name'
      data:
        user_name: $(this).val()
      success: (data) ->
        $("#User-Name-Info").empty()
        if data.status == 'true'
          $("#User-Name-Info").css "color", "green"
          $("#User-Name-Info").append "" + "Name: #{data.name} still can be used as your user name"
        else
          $("#User-Name-Info").css "color", "red"
          $("#User-Name-Info").append "" + "Sorry, name: #{data.name} has ever been registered by other users"
    return


