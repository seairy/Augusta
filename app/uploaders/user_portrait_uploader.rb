# -*- encoding : utf-8 -*-
class UserPortraitUploader < BaseUploader

  version :w300_h300_fl_q50 do
    process quality: 50
    process resize_to_fill: [300, 300]
  end
end
