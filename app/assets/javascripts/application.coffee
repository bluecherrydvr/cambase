#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require_tree .
#= require bootstrap
#= require editable/bootstrap-editable
#= require editable/rails
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
   e.stopPropagation()
   $('body').modalmanager('loading')
   $.rails.handleRemote( $(this) )

#removes whatever is in the modal body content div upon clicking close/outside modal
$(document).on 'click', '[data-dismiss=modal], .modal-scrollable', ->
  $('.modal-body-content').empty()
$(document).on 'click', '#signin-modal', (e) ->
  e.stopPropagation()

$ ->
  $fullsize_image_wrap = $(".fullsize-image")
  $('.clickable a').each ->
    target = $(this)
    target.attr('href', target.attr('data-href'))
    if target.attr('data-target') == "_blank"
      target.attr('target', "_blank")

  $container = $('#masonry-container')
  $container.packery
    itemSelector: '.tile',
    gutter: 0

  $('#search_dropdown').on 'click', ->
    $('.search-dropdown').slideToggle()

  $(".features span").on 'click', ->
    feature_id = $(this).attr("id").replace('_icon', '')
    $("##{feature_id}").trigger "click"
    $(this).toggleClass "selected"

  $(".features input[type=checkbox]").each ->
    if ( $(this).attr('checked') == 'checked' )
      image = "##{ $(this).attr('id') }_icon"
      $(image).addClass("selected")

  $('.module-images').on 'click', ".thumbnails img", (e) ->
    e.preventDefault()
    if $(this).hasClass "add-new-image"
      return
    clicked_image = $(this).attr('src')
    $('.module-image-main').attr('src', clicked_image)

  $('.module-information .editable:not(.additional_information)').editable
    emptytext: 'Unknown'
    toggle: 'manual'
    mode: 'inline'
    ajaxOptions:
      type: 'PUT'

  $('.module-information .editable.additional_information').editable
    emptytext: 'Unknown'
    toggle: 'manual'
    mode: 'inline'
    ajaxOptions:
      type: 'PUT'
    params: (params) ->
      $('.module-information .editable.additional_information').each ->
        target = $(this)
        attribute = target.attr('data-model')
        name = target.attr('data-name')
        value = target.attr('data-value')
        params["#{attribute}[#{name}]"] = value
      return params

  $('.module-manufacturer .editable').editable
    emptytext: 'Unknown'
    toggle: 'manual'
    ajaxOptions:
      type: 'PUT'

  $('.visitor-signed_in .module-table td.icon-edit').on "click", (e) ->
    e.preventDefault()
    e.stopPropagation()
    $(this).closest('tr').find('.editable').editable('toggle')

  $('.visitor-signed_out .add-new-image, .visitor-signed_out .icon-edit').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#signin-modal').modal()

  $('.visitor-signed_in .add-new-image').on "click", (e) ->
    e.preventDefault()
    $(this).closest('.module').find('input[type="file"]').trigger('click')

  $('.module input[type="file"]').change ->
    $(this).closest('.module').find('form').submit()

  $(".table-cameras a > img").on "mouseenter", ->
    img = this
    fullsize_image_url = $(img).attr('data-fullsize')
    $fullsize_image = $("<img src='#{fullsize_image_url}'>")
    offset = $(img).offset()
    $fullsize_image_wrap.css(
      top: offset.top - 50
      left: offset.left + 50
    ).append($fullsize_image).removeClass "hidden"

  $fullsize_image_wrap.add(".table-cameras a > img").on "mouseleave", ->
    $fullsize_image_wrap.empty().addClass "hidden"
