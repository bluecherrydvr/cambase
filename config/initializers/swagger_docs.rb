class Swagger::Docs::Config
  def self.transform_path(path)
    "api-docs/#{path}"
  end
end

base_path = Rails.env.development? ? "http://localhost:3000/" : "http://www.cambase.io/"

Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_extension_type => :json,
    :api_file_path => "public/api-docs",
    :base_path => base_path,
    :clean_directory => true
  }
})
