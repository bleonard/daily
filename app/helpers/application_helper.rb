module ApplicationHelper
  def title(text)
    @title = text
  end
  
  def page_title
    @title || "Daily"
  end
  
  def header_title
    @title
  end
end
