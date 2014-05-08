module PagesHelper
  def link_to_camera_url(name = camera.model, camera)
    link_to(name, "/#{camera.manufacturer.manufacturer_slug}/#{camera.camera_slug}")
  end
end
