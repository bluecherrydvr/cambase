class PagesController < ApplicationController
  def index
    @vendors = Vendor.order(:name)
  end
  def about_cambase
  end
  def about_evercam
  end
  def terms_of_service
  end
  def contact
  end
  def settings
    render 'devise/registrations/edit'
  end
end
