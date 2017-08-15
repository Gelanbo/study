# -*- coding: UTF-8 -*-
require 'uri'
require 'nokogiri'
require 'mechanize'
require 'sinatra'

class Grade
  def initialize(su,xuefe,grad,gradepoin,typ)
    @subj = su
    @xuefen = xuefe
    @grade = grad
    @gradepoint = gradepoin
    @type = typ
  end

  def get_sub
    "#@subj"
  end

  def get_xuefen
    "#@xuefen"
  end

  def get_grade
    "#@grade"
  end

  def get_gradepoint
    "#@gradepoint"
  end

  def get_type
    "#@type"
  end
end

host = Mechanize.new
url = host.get "http://202.119.113.135/loginAction.do"
form = url.forms[0]
code = host.get "http://202.119.113.135/validateCodeAction.do?random=0.27"
code.save! "code.jpg"

get '/' do
  erb:username
end

post '/' do
  username = form.field_with(:name => "zjh")
  password = form.field_with(:name => "mm")
  code = form.field_with(:name => "v_yzm")
  username.value = params[:username]
  password.value = params[:password]
  code.value = params[:code]
  result = host.submit form
  @result = "yes"
  result_text = result.parser.to_s.encode("UTF-8")
  if result_text.include?("密码不正确")
    @result = "用户名或密码错误"
    erb:fail
  elsif result_text.include?("验证码错误")
    @result = "验证码错误"
    erb:fail
  else
    @result = "登陆成功"
    page = host.get("http://202.119.113.135/gradeLnAllAction.do?type=ln&oper=qb")
    page_ = page.iframe.click
    page_.save! "score.html"
    html = Nokogiri::HTML(open("score.html").read,nil,"gbk")#
    subjects = html.css("tr.odd")
    @grade_array = []

    subjects.each do |m|
      g = m.children[13].text.strip.to_i
      g_ = m.children[13].text.strip.chop
      if g == 0
        if g_ == "优秀"
          gradepoint = 5
        elsif g_ == "良好"
          gradepoint = 4
        elsif g_ == "中等"
          gradepoint = 3
        elsif g_ == "及格"
          gradepoint = 2
        else
          gradepoint = 0
        end
      elsif g >= 90
        gradepoint = 5
      elsif g >= 85
        gradepoint = 4.5
      elsif g >= 80
        gradepoint = 4
      elsif g >= 75
        gradepoint = 3.5
      elsif g >= 70
        gradepoint = 3
      elsif g >= 65
        gradepoint = 2.5
      elsif g >= 60
        gradepoint = 2
      else
        gradepoint = 0
      end
      @grade_array << Grade.new(m.children[5].text.strip,m.children[9].text.strip,m.children[13].text.strip,gradepoint,m.children[11].text.strip)
    end
    $grade_a = @grade_array
    erb:login_result
  end
end

get '/gradepoint' do
  @type = 1
  @grade_array = $grade_a
  allpoint = 0
  allxuefen = 0
  $grade_a.each do |g|
    if g.get_type == "必修"
      allpoint = allpoint + g.get_xuefen.to_f * g.get_gradepoint.to_f
      allxuefen = allxuefen + g.get_xuefen.to_f
    end
  end
  @gradepoint = (allpoint / allxuefen).round(2)
  erb:login_result
end

get '/timg.jpg' do
  @code = File.open("code.jpg","r")
end
