Ruby网络爬虫：爬取教务系统成绩并实现绩点计算
====
* 根据最近学习的内容，稍微延伸到了用Ruby实现网络爬虫。目标是实现在网页上展示当前所有已公布成绩的课程成绩单，并一键计算绩点。<br>
* 四个路由分别用于渲染登录页面，登录判断以及成绩单页面，绩点计算和验证码显示。<br>
* 首页是登录页面，该页面包含一个登录表单，需要使用河海大学教务系统的账号（学号）和密码登录。对于登录信息的验证由教务系统的登录流程所决定：先判断验证码，再验证用户名以及密码。登陆成功后直接进入成绩单页面。<br>
* 成绩单页面，所有已经公布的成绩将以表格形式展示，包括“课程名”，“课程属性”，“学分”，“成绩“以及“绩点”。所有单元格设置为居中对齐。<br>
* 成绩单下面设置了”点击显示绩点“按钮，点击后将在该按钮的位置处显示总绩点。该绩点的计算未包含选修课成绩。<br>
* 运行：需要配置Ruby编译环境，并导入Ruby的nokogiri，mechanize，以及sinatra插件包。编译运行后在浏览器中打开本地网页（测试时是http://localhost:4567/ ）。
* 保持本程序的完善与更新。<br><br>参考资料：http://www.jianshu.com/p/f9988b9188c0
