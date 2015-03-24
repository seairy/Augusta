module V1
  Grape::Entity.class_eval do
    format_with(:timestamp) do |datetime|
      case datetime.class.to_s
      when 'Date' then datetime.to_datetime.to_i
      else datetime.to_i
      end
    end

    format_with(:float) do |float|
      float.try(:to_f)
    end

    def formatted_scorecards_status scorecards_status
      scorecards_status.map do |scorecard_status|
        if scorecard_status < 0
          "#{scorecard_status}"
        elsif scorecard_status == 0
          "E"
        else
          "+#{scorecard_status}"
        end
      end
    end
  end
end
