
require("TSLib");
require("baseMethods");
require("checkIP");
require("getToken");
require("getMobileNo");
require("getRegResources");
require("transtionImage");
require("remove_block");
require("applyHelp");
require("reApplyHelp");
require("reportResult");
require("get62Data");
require("transtion62Data");

toast('开始运行脚本...');
mSleep(1000);

clearAllPhotos();--清空相册
toast('清空相册...',1);

--请求地址配置 
baseUrl = "http://112.74.48.131:9090";
sid = "73612";
avatarLocalPath = "/private/var/mobile/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/avatar.JPG"
momentsPicLocalPath = "/private/var/mobile/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/momentsPic.JPG"

init("0", 0);																--初始化；
luaExitIfCall(true);														--设置来电时退出运行脚本
logFileName = "regWechat" .. getDeviceID() .. "_" .. os.date("%Y-%m-%d");
initLog(logFileName, 0); 													--初始化日志文件
wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Beginning..."); 	--启动是写入一条开始运行日志

unlock_phone(); 						--解锁手机
setDeviceOrient(0);						--设置竖屏模式
press_home(); 							--按home键回到主屏幕
deviceX,deviceY = getScreenSize(); 		--获取设备宽高
to_reset_phone();						--启动NZT一键新机
toggle_airModel();						--重新开启关闭飞行模式


run_app("com.apple.Preferences",3000);--启动“设置”
checkIPResult = false;					--检查IP是否可用
while(true) do

	--vpn已打开先关闭
	local x, y = findImage("preferences_VPN_connected.png", 0, 0, deviceX, deviceY);
	if (x ~= -1 and y ~= -1 ) then
		toast('vpn已经打开',1)
		touchDown(560, y+16);
		mSleep(67);
		touchUp(560, y+16);
		mSleep(1000);
	end
	
	open_VPN();
	while(true) do
		toast('获取IP地址中...',1)
	    IP = getNetIP();
		mSleep(1000)
	    if (type(IP) == "string") then
			checkDate = checkIPAvailable(baseUrl,IP);   --发送请求判断IP地址是否可用
			if checkDate.recommend then
				cityName = checkDate.area;
				cityCode = "";
				for index,code in utf8.codes(checkDate.area) do
					local bit = string.format("%s\\u%0x",index,code) .. ";";
					bit = string.sub(bit, 4, string.len(bit));
					cityCode = cityCode .. "&#x" .. bit
				end
				checkIPResult = true;
			end
			break;
	    else
			toast('获取IP失败，重新获取.');
			mSleep(1000)
		end
	end
	if (checkIPResult == true) then
		wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "IP:".. IP .. " is available");
		toast('IP地址可用.');
		break;
	else
		wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "IP:".. IP .. " is disavailable");
		toast('IP地址不可用，关闭VPN...');
		close_VPN();
	end
end


run_app("com.tencent.xin",4000);
toast('启动微信...');
click_point(473, 1046,2000);--点击“注册”,等待注册界面启动；

local x, y = findImage("has_choosed_china.png", 0, 0, deviceX, deviceY);
if (x == -1 and y == -1 ) then -- 没有找到就选择中国
	toast('选择中国...',1);
	click_point(353, 300,2000)--点击进入选择地区列表；
	click_point(624, 912,2000)--点击M定位到中国地区；
	click_point(353, 915,2000)--点击中国
end



for num = 1, 300 do
	toast('获取爱乐赞token...',1)
	token = getToken();
	if (token ~= nil) then
		break;
	end
	mSleep(2000)
end
if (token == nil) then
	log_and_restart("爱乐赞token获取失败.");
else
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Get token " .. token .. ".");
end
toast('爱乐赞token:' .. token,1);
mSleep(1000);


for num = 1, 100 do
	mobileNo = getCityMobileNo(token, sid, cityCode);
	if (mobileNo ~= nil) then
		toast("获取手机号为:" .. mobileNo)
		mSleep(1000)
		break;
	end
	toast("获取手机号失败",2)
	mSleep(3000)
end
if (mobileNo == nil) then
	log_and_restart("无法获取爱乐赞手机号");
else
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Get a mobile number:"  .. mobileNo .. ".");
end



--*********************************************************
-- 获取注册资源接口
--上传手机号到本地服务器记录，并开始下载保存图像和文本 

regResources = getRegResources(baseUrl,mobileNo,IP,cityName);
recordId = regResources.recordId;
nickname = regResources.nickname;
password = regResources.password;
avatarUrl = regResources.avatarUrl;
momentsPicUrl = regResources.momentsPicUrl;
momentsMsg = regResources.momentsMsg;

run_app("com.apple.mobilesafari");--启动“浏览器”
mSleep(2000);
safariDownloadImg(avatarUrl,"avatarImg")
mSleep(2000)
run_app("com.apple.mobilesafari");--启动“浏览器”
mSleep(2000);
safariDownloadImg(momentsPicUrl,"momentsImg")
mSleep(2000)

runApp("com.tencent.xin"); --回到微信
mSleep(2000)

--*********************************************************
	
	

--调接口爱乐赞发短信到10690700367，成功后点击发送短信。发送失败则重启微信，手机号不变
function ailezanSendMessage()
	--读取短信文字
	--老版微信发送手机号界面获取短信内容流程
	recognize = ocrText(25, 430, 120, 463, 0);  --OCR 英文识别，注意本函数仅对标准字体识别尚可，非标准字体请自行制作字库配合触动点阵识别函数效果更佳 
	mSleep(1000); 
	toast(recognize,1)
	
	-- body
	require("sentMessage")
	postMessageStatus = postMessage(token,sid,mobileNo,recognize,'10690700367'); --提交短信到爱乐赞平台
	if postMessageStatus then --提交10次了还不成功则重新该手机的注册流程
		toast('提交短信成功。')
		mSleep(1000)
		--提交成功,检测发送状态
		getMessageStatus = getMessageStatus(token,sid,mobileNo)
		if getMessageStatus then --检测30次短信发送是否成功
			wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "发送短信成功。");
			toast('短信发送成功。',1)
			mSleep(2000);
			
			--[[
			while (true) do
				--click_point(320,750,4000) -- 点击发送短信进入手机短信界面
				click_point(320,750,4000) -- 新版点击前往发送短信按钮进入手机短信界面
				click_point(590,590,8000) -- 点击发送按钮，成功后进入语音界面
				local x, y = findImage("send_mag_lose.png", 0, 0, deviceX, deviceY); --查看是否发送失败
				if (x ~= -1 and y ~= -1 ) then
					click_point(320,650,1000); --点击确定再次发送
					mSleep(1000)
				end
				mSleep(3000);
			end
			]]
			--click_point(320,750,4000) -- 点击发送短信进入手机短信界面
			--click_point(590,590,8000) -- 点击发送按钮，成功后进入语音界面
			click_point(320,750,2000) -- 新版点击前往发送短信按钮进入手机短信界面
			click_point(590,590,6000) -- 新版点击发送按钮，返回到短信页面
			--click_point(320,890,8000) -- 新版点击我已发送，下一步，进入语音界面
			
			for var= 1, 3 do  -- 有手机号已注册弹框
				local x, y = findImage("phone_had_reged.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(320,780,1000); --点击不是我的。继续注册
					break
				end
				mSleep(2000);
			end
			
			click_point(320,980,1000) -- 点击语音验证开始按钮
			toast("开始语音验证",1)
			
			
			for var= 1, 3 do  -- 查询是否有访问麦克风的提示弹框
				local x, y = findImage("allpy_user_voice.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(455,660,1000); -- 点击“好”进入语音验证
					break
				end
				mSleep(2000);
			end
			
			for var= 1, 4 do  -- 查询是否有重试
				local x, y = findImage("tryAgain.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(320,820,2000); 
					mSleep(4000)
				end
				mSleep(1000)
			end
			
			--*************************后续操作*****************
			--语音验证 --设昵称 --设图像 --发盆友圈
			local voiceStatus = false;
			while true do
				touchDown(320, 960); --按住4秒
				mSleep(4000);
				touchUp(320, 960);
				mSleep(4000);   --等待进入下一步页面
				click_point(320,960,3000) -- 点击下一步或点击重试
				--找语音验证成功的界面
				local x, y = findImage("voice_success.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					toast('声音验证成功...',1)
					voiceStatus = true;
					click_point(320,855,2000); --点击下一步设置昵称
					break
				end
				toast('再次声音验证，请等待...',1)
				mSleep(3000);
			end
			
			
			click_point(320,550,2000) 	-- 点击输入昵称输入框
			inputText(nickname);		--输入昵称 -- nickname
			mSleep(1000);
			click_point(320,590,3000) 	-- 点击下一步
			
			for var= 1, 6 do  -- 查找了解更多
				local x, y = findImage("learn_more.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(185,700,3000) 	-- 点击了解更多
					break
				end
				toast("了解更多弹窗没有找到",1)
				mSleep(1000);
			end
			
			for var= 1, 6 do  -- 查找点击同意并进入微信
				local x, y = findImage("remont_and_enter.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(310,970,3000) 	-- 点击同意并进入微信
					break
				end
				toast("同意并进入微信弹窗没有找到",1)
				mSleep(1000);
			end
			
			for var= 1, 3 do  -- 查询是否有访问通讯录的提示弹框
				local x, y = findImage("allpy_use_mail_list.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(190,680,3000) 	-- 点击不允许并进入微信
					break
				end
				toast("没有访问通讯录提示弹框",1)
				mSleep(1000);
			end
			
			for var= 1, 3 do  -- 提示好弹窗
				local x, y = findImage("notAddFriend_hao.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					toast("找到notAddFriend" .. x .. "|" .. y)
					click_point(320,700,6000); -- 点击微信无法访问通讯录提示，加载完后到微信主页
					break
				end
				mSleep(1000);
			end
	
			for var= 1, 3 do  -- 弹出无SIM卡，点击好
				local x, y = findImage("not_have_SIM.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(320,625,1000); --弹出无SIM卡，点击好
					break
				end
				mSleep(1000);
			end
			
			--click_point(320,690,6000) 	-- 点击微信无法访问通讯录提示，加载完后到微信主页
			click_point(560,1090,3000) 	-- 点击我设置图像
			click_point(320,250,3000) 	-- 点击图像
			click_point(320,240,3000) 	-- 点击图像选择
			click_point(590,83,3000) 	-- 点击右上角选更多
			click_point(320,880,3000) 	-- 点击从手机相册选择
			
			for var= 1, 3 do  -- 查询是否有访问相册的提示弹框
				local x, y = findImage("allpy_use_mail_list.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(455,680,3000) 	-- 点击好并进入相册
					break
				end
				toast("没有访问相册提示弹框",1)
				mSleep(1000);
			end
			
			
			
			click_point(320,180,3000) 	-- 点击打开系统相册
			click_point(80,210,3000) 	-- 点击选择第一张图片为图像
			click_point(560,1070,4000) 	-- 点击选择图像完成按钮
			click_point(100,80,3000) 	-- 点击选返回个人信息
			
			click_point(50,80,3000) 	-- 点击我返回首页
			click_point(400,1080,3000) -- 点击发现发盆友圈
			click_point(320,200,3000) -- 点击盆友圈
			click_point(590,85,3000) -- 点击相机图标
			
			for var= 1, 3 do -- 点击发朋友圈的提示框
				local x, y = findImage("have_know.png", 0, 0, deviceX, deviceY);
				if (x ~= -1 and y ~= -1 ) then
					click_point(320,755,1000); --点击知道了
					break
				end
				mSleep(1000);
			end
			
			click_point(320,980,3000) -- 点击从手机相册选择
			click_point(290,163,3000) -- 点击选择第二张图片

			click_point(550,1090,3000) -- 点击选择图片完成
			click_point(150,175,3000) -- 点击获取朋友圈文字输入框
			inputText(momentsMsg);--输入朋友圈文本 --momentsMsg
			mSleep(2000);
			click_point(590,78,5000) -- 点击发表
			click_point(70,80,3000) -- 点击发现返回首页
			
			click_point(560,1090,3000) -- 点击我设置密码
			click_point(320,850,3000) -- 点击设置
			click_point(320,200,3000) -- 点击账号与安全
			click_point(320,420,3000) -- 点击微信密码进入密码设置
			
			--读取微信id并保存
			weChatId = ocrText(180, 310, 570, 355, 0);  --OCR 英文数字识别，获取微信ID；6.6.0之前的旧版本为手机号，保存不用即可
			mSleep(1000); 
			toast("微信ID为：" .. weChatId,1)
			
			click_point(300,415,1000) -- 点击获取密码输入框
			inputText(password);--输入密码文本 --password
			mSleep(1000);
			click_point(320,877,1000) -- 点击再输入一个字母
			click_point(600,980,1000) -- 点击删除一下
			click_point(560,1090,1000) -- 点击完成Done
			
			click_point(300,500,1000) -- 点击获取确认密码输入框
			inputText(password);--输入密码文本 --password
			mSleep(1000);
			click_point(320,877,1000) -- 点击再输入一个字母
			click_point(600,980,1000) -- 点击删除一下
			click_point(560,1090,1000) -- 点击完成Done
			
			--密码设置完成，注册流程结束。 -- 获取62数据
			local data62 = get62Data(mobileNo,nickname,password);
			local transtionStatus = transtion62Data(baseUrl,recordId,data62,weChatId);
			if transtionStatus then
				toast("上传62数据成功",1)
			else
				toast("上传62数据失败",1)
			end
			log_and_restart("完成一个微信注册：手机号:" .. mobileNo .. "昵称:" .. nickname .. "密码:" .. password)
			
			--*************************后续操作*****************
		else
			toast('发送短信失败。');
			mSleep(1000)
			--reportResult(baseUrl,recordId,"false")			--上报验证失败结果
			local addBlackResult= addBlacklist(token, sid, mobileNo); --拉黑手机号
			if addBlackResult then
				toast("加入黑名单，重启脚本",1)
			end
			log_and_restart('发送短信失败！');
		end	
	else --
		toast('提交短信失败。');
		mSleep(1000)
		--reportResult(baseUrl,recordId,"false")			--上报验证失败结果
		local addBlackResult= addBlacklist(token, sid, mobileNo); --拉黑手机号
		if addBlackResult then
			toast("加入黑名单，重启脚本",1)
		end
		log_and_restart('提交短信失败！');
	end
end
--*******************************************************************



--从拿到手机号开始直到该手机号注册成功，此部分失败要使用该手机号重新走注册流程,尝试10次
--10次还是失败就放弃该手机号。重启脚本

firstApply = true;
for i=1,10 do
	for var= 1, 10 do
		if firstApply then 
			toast("该手机号首次注册微信",2);
		else --二次注册时重启微信
			run_app("com.tencent.xin",4000);
			toast('重启微信...');
			click_point(473, 1046,2000);--点击“注册”,等待注册界面启动；
			
			local x, y = findImage("has_choosed_china.png", 0, 0, deviceX, deviceY);
			if (x == -1 and y == -1 ) then -- 没有找到就选择中国
				toast('选择中国...',1);
				click_point(353, 300,2000)--点击进入选择地区列表；
				click_point(624, 912,2000)--点击M定位到中国地区；
				click_point(353, 915,2000)--点击中国
			end
		end
			
		click_point(300,400,2000); --获取手机号输入框焦点
--		local x, y = findImage("hasInputPhone.png", 0, 0, deviceX, deviceY); --验证失败点击关闭二次进入时会有手机号
--		if (x ~= -1 and y ~= -1 ) then
--			click_point(590,393,1000)
--		end
--		click_point(300,400,1000); --获取手机号输入框焦点

		inputText(mobileNo);--输入手机号码
		mSleep(2000);

		click_point(320,520,6000); --点击注册按钮
		
		--查找是否还有注册按钮，有就重启微信
		local x1, y1 = findImage("reg_btn_green.png", 0, 0, deviceX, deviceY);
		if (x1 == -1 and y1 == -1 ) then --没有找到就退出循环，表示成功
			toast('进入注册',1)
			mSleep(3000)
			break
		else --如果卡死在微信注册按钮点击无反应，则重启微信
			run_app("com.tencent.xin",2000);
			toast('重启微信...');
			click_point(473, 1046,2000);--点击“注册”,等待注册界面启动；
			
			local x, y = findImage("has_choosed_china.png", 0, 0, deviceX, deviceY);
			if (x == -1 and y == -1 ) then -- 没有找到就选择中国
				toast('选择中国...',1);
				click_point(353, 300,2000)--点击进入选择地区列表；
				click_point(624, 912,2000)--点击M定位到中国地区；
				click_point(353, 915,2000)--点击中国
			end
		end
	end
		

	while(true) do --同意协议
		local x, y = findImage("agreement.png", 0, 0, deviceX, deviceY,10000000);
		if (x ~= -1 and y ~= -1 ) then
			toast('agreement page is opened.',1)
			click_point(577,1090,1000); --点击同意协议
			break
		end
		toast('等待同意协议页面打开...',1)
		mSleep(1000);
	end

	while(true) do --安全验证开始按钮
		local x, y = findImage("begin_reg_btn_green.png", 0, 0, deviceX, deviceY);
		if (x ~= -1 and y ~= -1 ) then
			click_point(353,700,6000); --点击开始，进入滑块认证
			break
		end
		toast('等待安全验证开始页面打开...',1)
		mSleep(1000);
	end

	--等待滑块页面打开
	while(true) do
		local x, y = findImage("remove_page.png", 0, 0, deviceX, deviceY);
		if (x ~= -1 and y ~= -1 ) then
			aimx1,aimx2 = get_moveblock_position();						--计算滑块位置函数
			mSleep(2000)
			move_to(135,610,aimx1 + 50,610,6);
			mSleep(5000);
			--再找一次判断本次拖拽是否成功，不成功再来下一次
			local x1, y1 = findImage("remove_page.png", 0, 0, deviceX, deviceY);
			if (x1 == -1 and y1 == -1 ) then --滑块成功直接退出
				toast('滑块验证成功。',1)
				mSleep(2000);
				break
			else --滑块失败则先点击刷新换图再走计算验证
				toast("刷新图片验证",2)
				click_point(584,687,4000); --点击同意协议
			end
		end
		mSleep(1000);
		toast('等待滑块页面打开...',1)
	end


	local needAuthentication = false;
	--检测是否需要验证 --截取验证码页面的图片文字
	for var= 1, 6 do
		local x, y = findImage("need_authentication.png", 0, 0, deviceX, deviceY);
		if (x ~= -1 and y ~= -1 ) then
			needAuthentication = true
			break
		end
		mSleep(1000);
	end

	--[[*********************************************************
	--5分10秒内检测辅助结果：
		1.检测辅助成功： 上报辅助成功结果
		2.超时表明辅助失败： 上报辅助失败结果，点击关闭辅助界面，重新开始辅助
	--*********************************************************]]
	
	--首要要让人验证通过再去截图
	if (needAuthentication and firstApply) then --**************需要认证并首次提交验证申请******************
		
		--滑块验证成功，进入辅助验证页面等待
		toast('开始辅助验证',1)
		mSleep(4000);
		
		--截取二维码图片放在根目录的res文件中
		short_point_area_screen("qrImg.png",20,660,400,1050);
		toast('已保存二维码',1)
		mSleep(1000);
		
		--拼接二维码图片名
		local ts = require("ts")
		local time = ts.ms() * 10000
		local randomStr = ""
		for i = 1, 6 do
			local str = "abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
			local random = math.random(1, 52);
			randomStr = randomStr .. string.sub(str, random, random);
		end
		qrCodePath ="/qr-pic/" .. randomStr .. time .. ".png";
		toast("上传二维码到ftp", 1)
		uploadImg(userPath() .. "/res/qrImg.png",qrCodePath) --上传二维码到ftp
		
		
		--short_point_area_screen("checkSuccess.png",240,455,410,500)
		local firstApple = applyHelp(baseUrl,recordId,"ftp://112.74.48.131:213" .. qrCodePath) --第一次上报辅助验证
		if firstApple == false then --申请辅助失败
			reportResult(baseUrl,recordId,"false")			--上报验证失败结果
			local addBlackResult= addBlacklist(token, sid, mobileNo); --拉黑手机号
			if addBlackResult then
				toast("加入黑名单，重启脚本",1)
			end
			log_and_restart('申请辅助失败！');
		else
			--申请成功则下次申请为二次申请
			firstApply = false;
		end
		mSleep(3000)
		--申请成功等待验证
		local checkSuccess = false; --验证状态
		for var= 1, 100 do
			local x, y = findImage("checkSuccess.png", 0, 0, deviceX, deviceY);
			if (x ~= -1 and y ~= -1 ) then
				firstReg = false;
				checkSuccess = true;
				toast("验证通过",2)
				--****发验证通过的通知 成功通知***
				reportResult(baseUrl,recordId,"true") -- 上报辅助成功结果
				click_point(320,600,6000)
				ailezanSendMessage()
			end
			toast("暂未通过，waitting...",1)
			mSleep(3000)
		end
		if checkSuccess == false then
			--****发验证通过的通知***
			--点击关闭回到辅助验证等待
			reportResult(baseUrl,recordId,"false") -- 上报辅助失败结果
			click_point(160,80,3000) --点击关闭回到已输入手机号，点击注册界面
		end
	elseif needAuthentication then --*************二次提交验证申请*************************
		
		--滑块验证成功，进入辅助验证页面等待
		toast('开始辅助验证',1)
		mSleep(2000);
		
		--截取二维码图片放在根目录的res文件中
		short_point_area_screen("qrImg.png",20,660,400,1050);
		mSleep(2000)
		toast('已保存二维码',1)
		keepScreen(false);
		mSleep(1000)
		
		--拼接二维码图片名
		local ts = require("ts")
		local time = ts.ms() * 10000
		local randomStr = ""
		for i = 1, 6 do
			local str = "abcdefghigklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
			local random = math.random(1, 52);
			randomStr = randomStr .. string.sub(str, random, random);
		end
		qrCodePath ="/qr-pic/" .. randomStr .. time .. ".png";
		toast("上传二维码到ftp", 1)
		uploadImg(userPath() .. "/res/qrImg.png",qrCodePath) --上传二维码到ftp
		
		
		--short_point_area_screen("checkSuccess.png",240,455,410,500)
		local againAppleData = reApplyHelp(baseUrl,recordId,"ftp://112.74.48.131:213" .. qrCodePath) --第一次上报辅助验证
		if againAppleData == false then
			reportResult(baseUrl,recordId,"false")			--上报二次验证失败结果
			local addBlackResult= addBlacklist(token, sid, mobileNo); --拉黑手机号
			if addBlackResult then
				toast("加入黑名单，重启脚本",1)
			end
			log_and_restart('再次申请辅助失败！');
		else
			--更新数据
			recordId = againAppleData.recordId;
			nickname = againAppleData.nickname;
			password = againAppleData.password;
			avatarUrl = againAppleData.avatarUrl;
			momentsPicUrl = againAppleData.momentsPicUrl;
			momentsMsg = againAppleData.momentsMsg;
			mSleep(3000)
		end
			
		--二次申请成功等待验证
		local checkSuccess = false; --验证状态
		for var= 1, 100 do
			local x, y = findImage("checkSuccess.png", 0, 0, deviceX, deviceY);
			if (x ~= -1 and y ~= -1 ) then
				firstReg = false;
				checkSuccess = true;
				toast("验证通过",2)
				--****发验证通过的通知 成功通知***
				reportResult(baseUrl,recordId,"true") -- 上报辅助成功结果
				click_point(320,600,6000)
				ailezanSendMessage()
			end
			toast("暂未通过，waitting...",1)
			mSleep(3000)
		end
		if checkSuccess == false then
			--****发验证通过的通知***
			--点击关闭回到辅助验证等待
			reportResult(baseUrl,recordId,"false") -- 上报辅助失败结果
			click_point(160,80,3000) --点击关闭回到已输入手机号，点击注册界面
		end
	else --不需要认证的直接发短信
		ailezanSendMessage()
	end
end

toast("重取手机号开始脚本注册",1)
log_and_restart(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "该手机重试10次无效丢弃，冲去号注册");


