cover_preview = ->
  $('#session-cover-input').change ->
    if (this.files && this.files[0])
      reader = new FileReader()
      reader.onload = (e)->
        $("#default-session-cover").css("display", "none")
        $("#session-cover").css("display", "block")
        $("#session-cover").attr("src", e.target.result)
      reader.readAsDataURL(this.files[0])

@article_preview = ->
  cover_preview()
  $("#session-preview").on "click", ->
    mon_arr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    date = new Date()
    mm = date.getMonth()
    dd = date.getDate()
    $("#session-datetime").html('published on ' + mon_arr[mm] + " " + dd + " |")

    title = $("#session-title-input").val()
    $("#session-title").html("<h1>"+title+"</h1>")

    $("input:checked").each ->
      $("#article-session-categories").html($("#article-session-categories").html() + " " + $(this).next("label").text())

    if CKEDITOR.instances["article_description"]
      article_description = CKEDITOR.instances['article_description'].getData()
      $("#article-session-description").html(article_description)
