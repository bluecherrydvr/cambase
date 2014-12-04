class Swagger::Docs::Config
  def self.transform_path(path)
    "api-docs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_extension_type => :json,
    :api_file_path => "public/api-docs",
    :base_path => "http://www.cambase.io/",
    :clean_directory => true
  }
})
