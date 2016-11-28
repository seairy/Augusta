# -*- encoding : utf-8 -*-
module Cms::BaseHelper

  def brac_t attribute
    t "activerecord.attributes.#{attribute}"
  end

  def brac_image image, options = {}
    css_class = (['img-responsive'] << (options[:class] || 'img-thumbnail')).flatten.join(' ')
    if options[:thumb]
      if image.url
        image_tag(image, style: "width: 120px;", class: css_class)
      else
        'N/A'
      end
    else
      if image.url
        image_tag(image, class: css_class)
      else
        text_field_tag(nil, '无', readonly: true, class: 'form-control')
      end
    end
  end

  def brac_date date
    date.try(:strftime, '%Y-%m-%d') || 'N/A'
  end

  def brac_time date
    date.try(:strftime, '%H:%M') || 'N/A'
  end

  def brac_datetime datetime
    datetime.try(:strftime, '%Y-%m-%d %H:%M') || 'N/A'
  end

  def brac_styled_boolean value
    raw(value ? '<span class="label label-success">是</span>' : '<span class="label label-danger">否</span>')
  end

  def brac_flash
    dismiss_btn = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
    if flash[:alert]
      raw "<div class=\"alert alert-danger\">#{dismiss_btn}#{flash[:alert]}</div>"
    elsif flash[:notice]
      raw "<div class=\"alert alert-success\">#{dismiss_btn}#{flash[:notice]}</div>"
    end
  end

  def brac_paginate model
    paginate model
  end

  def styled_boolean_tag value, options = {}
    if options[:true_value].blank? or options[:false_value].blank?
      raw value ? "<span class=\"badge badge-success\">Y</span>" : "<span class=\"badge badge-important\">N</span>"
    else
      raw value ? "<span class=\"badge badge-success\">#{options[:true_value]}</span>" : "<span class=\"badge badge-important\">#{options[:false_value]}</span>"
    end
  end

  def hour_options
    options_for_select (6..18).map{|hour| ["#{hour.to_s.rjust(2, '0')}时", hour]}
  end

  def minute_options
    options_for_select (0..59).map{|minute| ["#{minute.to_s.rjust(2, '0')}分", minute]}
  end
end
