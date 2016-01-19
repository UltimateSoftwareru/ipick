require 'singleton'

class ObjectDefinitionsReader
  include Singleton

  def self.read
    path = "#{Rails.root}/config/object_definitions.yml"
    if path and File.exist?(path.to_s)
      result = YAML::load(File.open(path.to_s)).deep_symbolize_keys
    end
    result || {}
  rescue Psych::SyntaxError => e
    raise "YAML syntax error occurred while parsing #{path}. " \
          "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
          "Error: #{e.message}"
  end
end
