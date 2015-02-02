module Entities
  class User < Grape::Entity
    expose :uuid
    expose :nickname
    expose :token do |m, o|
      m.tokens.available.first.content
    end
  end
end