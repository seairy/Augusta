exceptions = %w(
  PermissionDenied
  InvalidGroups
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 