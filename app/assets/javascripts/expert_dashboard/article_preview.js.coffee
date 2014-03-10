cover_preview = ->
  $('#session-cover-input').change ->
    if (this.files && this.files[0])
      reader = new FileReader()
      reader.onload = (e)->
        $(".video-cover img").attr("src", e.target.result)
      reader.readAsDataURL(this.files[0])

@article_preview = ->
  cover_preview()
  $("#preview-button").on "click", ->
    mon_arr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    date = new Date()
    mm = date.getMonth()
    dd = date.getDate()
    $(".meta .date").html(mon_arr[mm] + " " + dd)

    title = $("#session-title-input").val()
    $(".meta .title").html(title)

    categories = []
    $("input:checked").each ->
      categories.push($(this).val())
    category = categories.join(',') + ''
    $(".meta .category").html(category)


    if CKEDITOR.instances["article_description"]
      article_description = CKEDITOR.instances['article_description'].getData()
      $(".detail article").html(article_description)
