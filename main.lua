require("TSLib");
require("baseMethods");
require("getAiLeZanToken");
require("getMobile");

require("getMobileAndToken");
require("getVcode");
require("remove_block");

toast('kaishia啦',10)
mSleep(3000)

init("0", 0);																--初始化；
luaExitIfCall(true);														--设置来电时退出运行脚本
logFileName = "regWechat" .. getDeviceID() .. "_" .. os.date("%Y-%m-%d");
initLog(logFileName, 0); 													--初始化日志文件
wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Beginning..."); 	--启动是写入一条开始运行日志

unlock_phone(); 						--解锁手机
setDeviceOrient(0);						--设置竖屏模式
press_home(); 							--按home键回到主屏幕
deviceW,deviceH = getScreenSize(); 		--获取设备宽高
--to_reset_phone();						--启动NZT一键新机
--toggle_airModel();					--重新开启关闭飞行模式

run_app("com.tencent.xin",4000);
nLog('启动微信');
click_point(473, 1046,1000);--点击“注册”,等待注册界面启动；

nLog('点击选择国家');
click_point(353, 300,2000)--点击进入选择地区列表；

click_point(624, 912,2000)--点击M定位到中国地区；

click_point(353, 915,2000)--点击M定位到中国地区


aiLeZanToken = getAiLeZanToken();
nLog('获取到爱乐赞的token为：' .. aiLeZanToken);
mSleep(2000);
phone = getMobile(aiLeZanToken);
nLog('获取到爱乐赞的手机号为：' .. phone);



mobileNo = '18376569152';
click_point(330,390,1000); --获取手机号输入框焦点

inputText(mobileNo);--输入手机号码
mSleep(2000);

click_point(353,520,2000); --点击注册按钮
nLog('1111')

click_point(577,1090,6000); --点击同意协议
nLog('2222')


mSleep(2000)
click_point(353,700,8000); --点击开始注册，进入滑块认证
nLog('3333')

nLog('移动滑块')
mSleep(4000)
aimx1,aimx2 = main();
mSleep(4000)
move_to(135,610,aimx1 + 45,610,10)
nLog(9999999)








