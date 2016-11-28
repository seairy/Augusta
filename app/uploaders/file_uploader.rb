# -*- encoding : utf-8 -*-
class FileUploader < BaseUploader
  def extension_white_list
    %w(apk)
  end
end