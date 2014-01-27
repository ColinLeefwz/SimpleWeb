side_bar = ->
	$(".item-text > a").on 'click', ->
		$(".item").find(".item-icon").css("display", "inline-block")
		$(this).parents(".item").find(".item-icon").css("display", "none")
		$(".item").find(".item-icon-selected").css("display", "none")
		$(this).parents(".item").find(".item-icon-selected").css("display", "inline-block")
		$(".item").find(".item-text > a").css("color", "")
		$(this).parents(".item").find(".item-text > a").css("color", "#880848")

validate_categoreis = ->
  $("#publish").on 'click', (e)->
    if $("input[type=checkbox]:checked").length == 0
      alert "You have to at least select one category"
      e.preventDefault()
    else
      confirm "Are you sure you want to publish this content and make it visible on the home page?"


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
  validate_categoreis()

$(document).on 'page:load', ->
  side_bar()
  validate_categoreis()

$(document).on 'ajax:success', ->
  validate_categoreis()
	(new AjaxEffect).start()
