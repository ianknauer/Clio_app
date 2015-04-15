module ApplicationHelper

  def name_with_status(name, status, user_id)
    link_to(name, user_path(user_id), :class => "name other") +
      content_tag(:span, status, :class => "status status-#{status}")
  end

end
