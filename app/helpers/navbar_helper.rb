module NavbarHelper
  def active_class(path)
    "active text-primary fw-bold" if request.path.start_with?(path)
  end
end
