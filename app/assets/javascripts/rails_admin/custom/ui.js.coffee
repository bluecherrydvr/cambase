$(document).on 'rails_admin.dom_ready', ->

  $('.history_approve_contribution').on 'click', (e) ->
    version_id = $(this).attr('data-id')
    $.ajax
      type: "POST"
      url: "/versions/"
      data:
        version_id: version_id
      dataType: "json"
      success: (msg) ->
        alert "Data Saved: " + msg
        return
