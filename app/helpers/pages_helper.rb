module PagesHelper
  def link_to_model_url(name = model.model, model)
    link_to(name, "/#{model.vendor.vendor_slug}/models/#{model.model_slug}")
  end
end
