ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at("input,select,textarea")

  html = if field
           error_message = instance_tag.error_message.join(", ")
           field["class"] = "#{field['class']} border border-danger"
           html = <<-HTML
              #{fragment}
              <p class="mt-1 small text-danger">#{error_message.upcase_first}</p>
           HTML
           html
  else
           html_tag
  end

  html.html_safe
end
