desc "Sort a .yml file alphabetically by its keys or all .yml files in config/locales if no file specified"
task :sort_yaml, [ :file_path ] => :environment do |_, args|
  require "yaml"

  # A method to recursively sort a hash by its keys
  def deep_sort(obj)
    return obj unless obj.is_a?(Hash)

    sorted = obj.sort_by { |key, _| key }.to_h
    sorted.each do |key, value|
      sorted[key] = deep_sort(value) if value.is_a?(Hash)
    end
    sorted
  end

  def sort_file(file_path)
    if File.exist?(file_path)
      yaml_content = YAML.load_file(file_path)
      sorted_yaml = deep_sort(yaml_content)
      sorted_yaml_string = sorted_yaml.to_yaml(lines_style: :flow)
      File.open(file_path, "w") { |file| file.write(sorted_yaml_string) }
      puts("YAML file sorted successfully: #{file_path}")
    else
      puts("File not found: #{file_path}")
    end
  end

  file_path = args[:file_path]
  if file_path
    sort_file(file_path)
  else
    Dir.glob("config/locales/**/*.yml").each do |file_path|
      sort_file(file_path)
    end
  end
end
