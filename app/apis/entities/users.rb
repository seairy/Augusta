module Entities
  class User < Grape::Entity
    expose :uuid
    expose :state
    expose :available_token
  end
end