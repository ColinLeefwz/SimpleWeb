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
		@session_preview()

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

	session_preview: ->
		$("#session-preview").on "click", ->
      mon_arr = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
      date = new Date()
      mm = date.getMonth()
      dd = date.getDate()
      $("#session-datetime").html('originally published on ' + mon_arr[mm] + " " + dd + " |")

      title = $("#session-title-input").val()
      $("#session-title").html("<h1>"+title+"</h1>")

      $("input:checked").each( ->
        $("#article-session-categories").html($("#article-session-categories").html() + " " + $(this).next("label").text())
        $("#live-session-categories").html($("#live-session-categories").html() + "<p>" + $(this).next("label").text() + "</p>")
      )
      if(CKEDITOR.instances["live_session_description"] != undefined)
        live_description = CKEDITOR.instances["live_session_description"].getData()
        $("#live-session-description").html(live_description)
      if(CKEDITOR.instances["article_session_description"] != undefined)
        article_description = CKEDITOR.instances['article_session_description'].getData()
        $("#article-session-description").html(article_description)

$(document).ready(side_bar)
$(document).on 'page:load', side_bar

$(document).on 'ajax:success', ->
	(new AjaxEffect).start()
