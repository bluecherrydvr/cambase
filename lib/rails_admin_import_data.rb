require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
require Rails.root.join('lib', 'import_data.rb')

module RailsAdminPublish
end

module RailsAdmin
  module Config
    module Actions
      class ImportCSV < RailsAdmin::Config::Actions::Base
        register_instance_option :link_icon do
          'icon-list-alt'
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :controller do
          Proc.new do
            download_csv_from_google_drive

            import_csv_from_google_drive

            redirect_to back_or_index
          end
        end
      end
      class ImportImages < RailsAdmin::Config::Actions::Base
        register_instance_option :link_icon do
          'icon-picture'
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :controller do
          Proc.new do

            flash[:notice] = "Image import started"

            call_rake('import_images_from_google_drive')

            redirect_to back_or_index
          end
        end
      end
    end
  end
end
