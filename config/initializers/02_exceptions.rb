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
  InvalidPasswordConfirmation
  InvalidOriginalPassword
  DuplicatedParticipant
  InvalidState
  InvalidMatchType
  PlayerNotFound
  HoledStrokeNotFound
  DuplicatedHoledStroke
  InvalidMatchState
  NotEnoughPassword
  TooManyRequest
  InvalidUserType
  VersionNotFound
  InvalidDistance
  InvalidPointOfFall
)
exceptions.each{|e| Object.const_set(e, Class.new(StandardError))} 