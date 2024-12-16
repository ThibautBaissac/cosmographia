namespace :i18n do
  desc "Compare localization keys across all locales and identify missing keys"
  task missing_keys: :environment do
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

    puts "🔍 Starting to compare localization keys across all locales..."

    # Step 1: Collect defined keys from YAML files
    locales_dir = "config/locales"
    locale_files = Dir.glob("#{locales_dir}/**/*.yml")

    # Organize keys per locale
    keys_per_locale = {} # locale => Set of keys

    locale_files.each do |file|
      begin
        data = YAML.load_file(file)
        next unless data.is_a?(Hash)
        data.each do |locale, translations|
          next unless translations.is_a?(Hash)
          keys_per_locale[locale] ||= Set.new
          extracted_keys = extract_keys(translations)
          keys_per_locale[locale].merge(extracted_keys)
        end
      rescue Psych::SyntaxError => e
        puts("⚠️  YAML Syntax Error in file #{file}: #{e.message}")
      end
    end

    # Ensure all locales are symbols for consistency
    locales = keys_per_locale.keys.map(&:to_s).sort
    puts "📁 Found locales: #{locales.join(', ')}"

    # Step 2: Collect all unique keys across all locales
    all_keys = keys_per_locale.values.reduce(Set.new, :|)
    puts "🔑 Total unique keys across all locales: #{all_keys.size}"

    # Step 3: Identify missing keys per key
    missing_keys_report = {} # key => Set of missing locales

    all_keys.each do |key|
      missing_locales = locales.select { |locale| !keys_per_locale[locale].include?(key) }
      unless missing_locales.empty?
        missing_keys_report[key] = missing_locales
      end
    end

    # Step 4: Report
    if missing_keys_report.empty?
      puts "🎉 All keys are present in every locale. No missing keys found!"
    else
      puts "\n❌ Found #{missing_keys_report.size} keys missing in some locales:"

      missing_keys_report.each do |key, missing_locales|
        puts "  - #{key}"
        puts "    Missing in locales: #{missing_locales.join(', ')}"
      end

      # Optional: Summary per locale
      puts "\n📊 Summary of missing keys per locale:"
      locales.each do |locale|
        missing_count = missing_keys_report.count { |_, locales_missing| locales_missing.include?(locale) }
        puts "  - #{locale}: #{missing_count} missing key(s)"
      end
    end
  end
end
