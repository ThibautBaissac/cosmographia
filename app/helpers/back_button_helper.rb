module BackButtonHelper
  def previous_page_link(path)
    if request.path.start_with?(path) && request.referer.present?
      request.referer
    else
      path || root_path
    end
  end
end
