# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('form').on 'click', '.disconnect_fields', (event) ->
    confirmed = confirm(" Are you sure?" )
    if confirmed
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('tr').hide()
      event.preventDefault()
    

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

	$('#editBuildingsTab a').on 'click', (e) ->
  	event.preventDefault()
  	$(this).tab('show')
	
	$('#editBuildingTab').tab()