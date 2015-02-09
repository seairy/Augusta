exceptions = %w(
  PermissionDenied
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 