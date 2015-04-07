# -*- encoding : utf-8 -*-
class APIError
  @contents = {
    # 10001 ~ 19999: 通用
    10001 => { status: 401, message: 'Token失效' },
    10002 => { status: 404, message: '数据未找到' },
    10003 => { status: 403, message: '访问非当前用户数据' },
    10004 => { status: 404, message: 'API不存在' },
    # 20101 ~ 20199: 记分卡
    20101 => { message: '无效的球场' },
    20102 => { message: '专业记分方式无法修改记分卡' },
    20103 => { message: '简单记分方式无法修改击球记录' },
    # 20201 ~ 20299: 统计

    # 20301 ~ 20399: 个人中心
    20301 => { message: '请求验证码过于频繁' },
    20302 => { message: '未注册过的用户' },
    20303 => { message: '用户重复注册' },
    20304 => { message: '无效的验证码' },
    20305 => { message: '无效的用户状态' },
    20306 => { message: '无效的密码' },
    20307 => { message: '无效的昵称' },
    20308 => { message: '无效的性别' },
    20309 => { message: '无效的确认密码' },
    20310 => { message: '无效的原密码' },
  }

  class << self
    def method_missing(sym, *args, &block)
      if sym =~ /^code_\d{5}$/
        content = @contents[sym.to_s.scan(/^code_(\d{5})$/)[0][0].to_i]
        content.merge!(status: 200) unless content.has_key?(:status)
        content
      else
        super(sym, *args, &block)
      end
    end

    def message(code)
      @contents[code][:message]
    end
  end
end