# -*- encoding : utf-8 -*-
class Caddie::SessionsController < Caddie::BaseController
  skip_before_filter :authenticate

  def oauth2
    redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx17c92cbd610540b7&redirect_uri=http%3A%2F%2Filovegolfclub.com%2Fcaddie%2Fsignin_with_open_id&response_type=code&scope=snsapi_base&state=caddiesignin#wechat_redirect'
  end

  def create_with_open_id

  end
end
