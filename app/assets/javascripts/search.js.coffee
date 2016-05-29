$ ->
  $('#js-search-field').typeahead
    name: 'search'
    remote: "/search/autocomplete?query=%QUERY"
