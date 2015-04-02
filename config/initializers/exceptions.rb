exceptions = %w(
  PermissionDenied
  InvalidGroups
  InvalidScoringType
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 