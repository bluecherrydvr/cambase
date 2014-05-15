class PagesController < ApplicationController
  def index
    @images = Image.last(24).reverse
  end
  def about_cambase
  end
  def about_evercam
  end
  def privacy
  end
  def cookie
  end
  def contact
  end
end
