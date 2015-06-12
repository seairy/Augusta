# -*- encoding : utf-8 -*-
class APIError
  @contents = {
    # 10001 ~ 19999: 系统
    10001 => { status: 401, message: 'Token失效' },
    10002 => { status: 404, message: '数据未找到' },
    10003 => { status: 403, message: '访问非当前用户数据' },
    10004 => { status: 404, message: 'API不存在' },
    10005 => { status: 408, message: '请求超时' },
    10006 => { status: 404, message: '没有任何版本' },
    # 20101 ~ 20199: 比赛
    20101 => { message: '无效的球场' },
    20102 => { message: '专业记分方式无法修改记分卡' },
    20103 => { message: '简单记分方式无法修改击球记录' },
    20104 => { message: '记分卡类型错误' },
    20105 => { message: '不是竞技赛事' },
    20106 => { message: '无效的密码' },
    20107 => { message: '用户重复参加赛事' },
    20108 => { message: '赛事已结束' },
    20109 => { message: '用户未参加该赛事' },
    20110 => { message: '没有进洞击球' },
    20111 => { message: '重复进洞击球' },
    20112 => { message: '无可分配密码' },
    20113 => { message: '比赛口令错误' },
    20114 => { message: '无效的距离' },
    20115 => { message: '无效的落点' },
    20116 => { message: '无效的球杆' },
    # 20201 ~ 20299: 统计
    20201 => { message: '必须选择一种统计方式' },
    # 20301 ~ 20399: 个人
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
    20311 => { message: '无效的头像' },
    20312 => { message: '无效的签名' },
    20313 => { message: '无效的出生日期' },
    20314 => { message: '无效的基本信息' },
    20315 => { message: '请求验证码次数过多' },
    20316 => { message: '非游客用户无法升级' },
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
