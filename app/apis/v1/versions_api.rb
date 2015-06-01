# -*- encoding : utf-8 -*-
module V1
  module Versions
    module Entities
      class Version < Grape::Entity
        expose :code
        expose :name
        expose :file
        expose :description
      end
    end
  end

  class VersionsAPI < Grape::API
    resources :versions do
      desc '获取最新版本'
      get :newest do
        begin
          version = Version.newest
          raise VersionNotFound.new unless version
          present version, with: Versions::Entities::Version
        rescue VersionNotFound
          api_error!(10006)
        end
      end
    end
  end
end
