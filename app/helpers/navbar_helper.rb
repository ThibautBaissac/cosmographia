module NavbarHelper
  def active_class(path)
    "active text-primary fw-bold" if current_page?(path)
  end
end
