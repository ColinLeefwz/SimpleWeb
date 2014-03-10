
@autocomplete_on = ->
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

  $("#search_field").typeahead({displayKey: "value",minLength: 3}, {source: engine.ttAdapter()})
