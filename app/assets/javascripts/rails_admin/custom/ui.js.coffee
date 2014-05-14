$(document).on 'rails_admin.dom_ready', ->
  console.log 'loaded'

  $('.history_approve_contribution').on 'click', (e) ->
    version_id = $(this).attr('data-id')
    console.log 'clicked'
    $.ajax
      type: "POST"
      url: "/versions/"
      data:
        version_id: version_id
      dataType: "json"
      success: (msg) ->
        alert "Data Saved: " + msg
        return
