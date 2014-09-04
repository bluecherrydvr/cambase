class PagesController < ApplicationController
  def index
    @images = Image.where(owner_type: ["Manufacturer"]).all().reverse
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
