# -*- encoding : utf-8 -*-
class Caddie::CaddiesController < Caddie::BaseController
  skip_before_filter :authenticate
end
