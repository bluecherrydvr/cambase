#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require_tree .
#= require bootstrap
#= require swagger-ui
#= require get-style-property
#= require get-size
#= require matches-selector
#= require eventEmitter
#= require eventie
#= require doc-ready
#= require classie
#= require jquery-bridget
#= require matches-selector
#= require outlayer/item
#= require outlayer
#= require packery/rect
#= require packery/packer
#= require packery/item
#= require packery

# called from a bootstrap dropdown, this closes the dropdown
$('a[data-toggle=modal]').on 'click', ->
  $('.dropdown').removeClass('open')

# this sets up the ajax loader, and it will stay until the method specific js removes it
$('a[data-target=#signin-modal]').on 'click', ->
   e.preventDefault()
   e.stopPropagation();
   $('body').modalmanager('loading');
   $.rails.handleRemote( $(this) );

#removes whatever is in the modal body content div upon clicking close/outside modal
$(document).on 'click', '[data-dismiss=modal], .modal-scrollable', ->
  $('.modal-body-content').empty()
$(document).on 'click', '#signin-modal', (e) ->
  e.stopPropagation();

$ ->
  $container = $('#masonry-container')
  $container.packery
    itemSelector: '.tile',
    gutter: 0

  $('#search_dropdown').on 'click', ->
    $('.search-dropdown').slideToggle()
