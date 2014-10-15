module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def model
    @model ||= Model.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-error", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=16&d=mm&f=y"
  end

  def xeditable? object = nil
    true
  end

  def combine_features
    any_feature = Model::FEATURES.map { |n| n.parameterize.underscore }
    any_feature = any_feature.inject { |x, y| "#{x}_or_#{y}" }
    any_feature = "#{any_feature}_true"
  end
end

