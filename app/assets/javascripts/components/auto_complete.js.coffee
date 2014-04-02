
@autocomplete_on = ->
  # initialize the search field
  engine = new Bloodhound({
    remote: {
      url: '/search/autocomplete?query=%QUERY',
      filter: (respondJSON)->
        return $.map respondJSON, (item)->
          return {value: item.val}
    },

    datumTokenizer: (d) ->
      return Bloodhound.tokenizers.whitespace(d.val)
    ,
    queryTokenizer: Bloodhound.tokenizers.whitespace
  })

  engine.initialize()

  $("#search_field").typeahead({displayKey: "value", highlight: true}, {source: engine.ttAdapter()})


  # animation on type and selection
  $(document).on "typeahead:opened", ->
    $(".dropdown-menu li").fadeOut()

  $(document).on "typeahead:closed", ->
    $(".dropdown-menu li").fadeIn()

  $(document).on "typeahead:cursorchanged", (event, suggestion, dataset) ->
    $(".tt-suggestion").css({"background-color": "white", "color": "black"})
    $('.tt-suggestion:contains(' + suggestion.value + ')').css({"background-color": "#428bca", "color": "white"})

  $("#search_field").css("background-color": "white")
