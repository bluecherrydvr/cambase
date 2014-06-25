require Rails.root.join('lib', 'rails_admin_approve_change.rb')
require Rails.root.join('lib', 'rails_admin_import_data.rb')

module RailsAdmin
  module Config
    module Actions
      class ImportCSV < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end
      class ImportImages < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      end
    end
  end
end

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show

    import_csv
    import_images

  end
end
