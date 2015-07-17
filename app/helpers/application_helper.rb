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

  def human_tee_box_color tee_box_color
    case tee_box_color
    when :red then '红'
    when :white then '白'
    when :blue then '蓝'
    when :black then '黑'
    when :gold then '金'
    else '未知'
    end
  end

  def human_direction direction
    case direction
    when :hook then '左侧'
    when :pure then '命中'
    when :slice then '右侧'
    else '未知'
    end
  end

  def human_scoring_type scoring_type
    case scoring_type
    when :simple then '简单记分'
    when :professional then '专业记分'
    else '未知'
    end
  end
end
