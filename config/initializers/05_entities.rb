module V1
  Grape::Entity.class_eval do
    format_with(:timestamp) do |datetime|
      case datetime.class.to_s
      when 'Date' then datetime.to_datetime.to_i
      else datetime.to_i
      end if datetime
    end

    format_with(:float) do |float|
      float.try(:to_f)
    end

    format_with(:image) do |image|
      float.try(:to_f)
    end

    def oss_image object, asset_name, version
      object ? (object.send("#{asset_name}?") ? object.send(asset_name).send(version) : nil) : nil
    end
  end
end
