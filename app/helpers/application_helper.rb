# -*- encoding : utf-8 -*-
module ApplicationHelper
  def formatted_status status
    if status < 0
      "#{status}"
    elsif status.zero?
      'E'
    elsif status > 0
      "+#{status}"
    end if status
  end
end
