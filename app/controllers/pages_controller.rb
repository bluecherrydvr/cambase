class PagesController < ApplicationController
  def index
    @data = []
    @images = Image.last(24).reverse
    @images.each do |image|
      owner = image.owner_type.classify.constantize.find(image.owner_id)
      @data.push(owner)
    end
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
