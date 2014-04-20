module ActiveAdmin::ViewsHelper
  def kuwasys_status_tag_color(status_name)
    if status_name == 'active'
      return 'green'
    elsif status_name == 'waiting'
      return 'orange'
    else
      return ''
    end
  end
end