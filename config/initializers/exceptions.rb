exceptions = %w(
  PermissionDenied
  InvalidGroups
  InvalidScoringType
  FrequentRequest
  PhoneNotFound
  InvalidVerificationCode
  DuplicatedPhone
  InvalidPassword
  InvalidStatus
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 