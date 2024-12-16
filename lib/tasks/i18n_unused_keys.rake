namespace :i18n do
  desc "Identify unused I18n localization keys"
  task unused_keys: :environment do
    require "yaml"
    require "set"

    # Helper method to recursively extract keys from a hash
    def extract_keys(hash, parent_key = nil)
      keys = []
      hash.each do |key, value|
        full_key = parent_key ? "#{parent_key}.#{key}" : key.to_s
        if value.is_a?(Hash)
          keys.concat(extract_keys(value, full_key))
        else
          keys << full_key
        end
      end
      keys
    end

    # Helper method to check if any parent key is used
    def parent_key_used?(key, used_keys)
      while key.include?(".")
        key = key.rpartition(".").first
        return true if used_keys.include?(key)
      end
      false
    end

    puts "🔍 Starting to scan for unused I18n keys..."

    # Step 1: Collect used keys from code
    used_keys = Set.new

    # Define patterns to match t('key') or I18n.t("key")
    # This regex handles single and double quotes, ignores interpolation
    key_pattern = /(?:I18n\.)?t\(\s*['"]([^'"]+)['"]\s*[,\)]/

    # Scan .html.erb files
    view_files = Dir.glob("app/views/**/*.html.erb")
    view_files.each do |file|
      File.foreach(file) do |line|
        line.scan(key_pattern) do |match|
          used_keys << match.first
        end
      end
    end

    # Scan .rb files in app/
    rb_files = Dir.glob("app/**/*.rb")
    rb_files.each do |file|
      File.foreach(file) do |line|
        line.scan(key_pattern) do |match|
          used_keys << match.first
        end
      end
    end

    puts "📋 Total used keys found: #{used_keys.size}"

    # Step 2: Collect defined keys from YAML files
    locales_dir = "config/locales"
    locale_files = Dir.glob("#{locales_dir}/**/*.yml")

    # Organize keys per locale and per file
    locale_file_keys = {}           # locale => file => set of keys
    defined_keys_per_locale = {}    # locale => set of keys

    locale_files.each do |file|
      begin
        data = YAML.load_file(file)
        next unless data.is_a?(Hash)
        data.each do |locale, translations|
          next unless translations.is_a?(Hash)
          locale_file_keys[locale] ||= {}
          locale_file_keys[locale][file] ||= Set.new
          keys = extract_keys(translations)
          locale_file_keys[locale][file].merge(keys)
          defined_keys_per_locale[locale] ||= Set.new
          defined_keys_per_locale[locale].merge(keys)
        end
      rescue Psych::SyntaxError => e
        puts("⚠️  YAML Syntax Error in file #{file}: #{e.message}")
      end
    end

    # Step 3: Compare and find unused keys per locale
    unused_keys_per_locale = {}

    defined_keys_per_locale.each do |locale, keys|
      unused = keys - used_keys
      # Optional Enhancement: Flag nested keys as unused if their parent keys are not used
      filtered_unused = unused.select do |key|
        !parent_key_used?(key, used_keys)
      end
      unused_keys_per_locale[locale] = filtered_unused
    end

    # Step 4: Report
    unused_keys_per_locale.each do |locale, unused_keys|
      next if unused_keys.empty?
      puts "\n📁 Unused keys for locale '#{locale}':"

      # For each file, list unused keys
      locale_file_keys[locale].each do |file, keys_in_file|
        file_unused = keys_in_file & unused_keys
        next if file_unused.empty?
        puts "  📄 In file #{file}:"
        file_unused.to_a.sort.each do |key|
          puts "    - #{key}"
        end
      end
    end

    # Optional: Summary
    total_unused = unused_keys_per_locale.values.map(&:size).sum
    puts "\n✅ Total unused keys: #{total_unused}"
  end
end
