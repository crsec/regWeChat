
require("TSLib");
require("baseMethods");
require("checkIP");
require("getToken");
require("getMobileNo");
require("transtionImage");
require("remove_block");


toast('start script...');
--toast(userPath(),1);
mSleep(1000);

clearAllPhotos();--清空相册
toast('clear photo success...',2);

--请求地址配置
baseUrl = "http://119.23.142.95:7001/card-pool-api";

--local fileString = readFileString(userPath().."/res/remove_page.png") --读取文件内容，返回全部内容的string

init("0", 0);																--初始化；
luaExitIfCall(true);														--设置来电时退出运行脚本
logFileName = "regWechat" .. getDeviceID() .. "_" .. os.date("%Y-%m-%d");
initLog(logFileName, 0); 													--初始化日志文件
wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Beginning..."); 	--启动是写入一条开始运行日志

unlock_phone(); 						--解锁手机
setDeviceOrient(0);						--设置竖屏模式
press_home(); 							--按home键回到主屏幕
deviceX,deviceY = getScreenSize(); 		--获取设备宽高
--to_reset_phone();						--启动NZT一键新机
--toggle_airModel();					--重新开启关闭飞行模式


checkIPResult = false;					--检查IP是否可用
while(true) do
	vpnStatus = getVPNStatus();
	if vpnStatus.active then
		getVPNStatus(false)
	end
	open_VPN();
	while(true) do
		toast('gitting IP...',2)
	    IP = getNetIP();
		mSleep(2000)
	    if (type(IP) == "string") then
			toast('has geted IP:' .. IP);
		    --[[
			checkDate = checkIPAvailable(IP);   --发送请求判断IP地址是否可用
			if checkDate.recommend then
				area = checkDate.area;
				checkIPResult = true;
			end
			]]
			break;
	    end
		toast('get IP failure...');
		mSleep(1000);
	end
	if (checkIPResult == true) then
		wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "IP:".. IP .. " is available");
		toast('IP available.');
		break;
	else
		wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "IP:".. IP .. " is disavailable");
		toast('IP disavailable,clase VPN...');
		close_VPN();
	end
end


run_app("com.tencent.xin",4000);
toast('start weChat...');
click_point(473, 1046,1000);--点击“注册”,等待注册界面启动；

toast('choose China...',2);
click_point(353, 300,2000)--点击进入选择地区列表；
click_point(624, 912,2000)--点击M定位到中国地区；
click_point(353, 915,2000)--点击中国


for num = 1, 300 do
	toast('getting token...',2)
	token = getToken();--token:de6c0e9d-acfc-4e5b-9a6f-6f6c461d7c40
	if (token ~= nil) then
		break;
	end
	mSleep(2000)
end
if (token == nil) then
	log_and_restart("Get token failed.");
else
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Get token " .. token .. ".");
end
toast('ailezan token:' .. token,2);
mSleep(2000);


sid = "73612";
for num = 1, 300 do
	--mobileNo = getMobileNo(token, sid);
	--mobileNo = getCityMobileNo(token, sid, area);  --&#x5F00;&#x5C01;
	mSleep(1000)
	mobileNo = '17183014349';--18094595172
	toast(mobileNo,3);
	mSleep(3000);
	if (mobileNo ~= nil) then
		break;
	end
end
if (mobileNo == nil) then
	log_and_restart("Get mobile number failed.");
else
	wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "Get a mobile number:"  .. mobileNo .. ".");
end
toast('手机号：' .. mobileNo);



--*********************************************************
-- 获取注册资源接口
--[[上传手机号到本地服务器记录，并开始下载保存图像和文本  -- 异步执行
regResources = getRegResources(baseUrl,mobileNo);
downloadImg(regResources.avatarUrl);
mSleep(3000);
downloadImg(regResources.momentsPicUrl);

--*********************************************************]]
	
	

--调接口爱乐赞发短信到10690700367，成功后点击发送短信。发送失败则重启微信，手机号不变
function ailezanSendMessage()
	--读取短信文字
	recognize = ocrText(25, 430, 120, 463, 0);  --OCR 英文识别，注意本函数仅对标准字体识别尚可，非标准字体请自行制作字库配合触动点阵识别函数效果更佳 
	mSleep(1000); 
	toast(recognize,2)  --recognize短信内容
	mSleep(2000);
	-- body
	require("sentMessage")
	postMessageStatus = postMessage(token,sid,mobileNo,recognize,'10690700367'); --提交短信到爱乐赞平台
	if postMessageStatus then --提交10次了还不成功则重新该手机的注册流程
		toast('提交短信成功。')
		--提交成功,检测状态
		getMessageStatus = getMessageStatus(token,sid,mobileNo)
		if getMessageStatus then --检测30次短信发送是否成功
			wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "发送短信成功。");
			toast('短信发送成功。',3)
			mSleep(3000);
			click_point(320,750,4000) -- 点击发送短信进入手机短信界面
			click_point(590,590,30000) -- 点击发送按钮，等待提示
			local flag = false;
			
			--*************************后续操作*****************
			--语音验证 --设昵称 --设图像 --发盆友圈
			while(true) do
				short_point_area_screen("send_msg_lose_btn.png",280,635,360,675);--截取未收到验证码的确认提示按钮
				local x, y = findImage("send_msg_lose_btn.png", 0, 0, deviceX, deviceY);
				toast('message lose' .. x .. '|' .. y,1);
				if (x ~= -1 and y ~= -1 ) then
					toast('message lose',1)
					click_point(x+40,y+20,2000); --点击同意协议
					
					break
				end
				mSleep(1000);
				toast('message lose...',1)
			end
			--*************************后续操作*****************
		else
			wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "发送短信失败。");
		end	
	else
		toast('提交短信失败。')
		wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "提交短信失败。");
	end
end
--*******************************************************************





--从拿到手机号开始直到该手机号注册成功，此部分失败要使用该手机号重新走注册流程,尝试10次
--10次还是失败就放弃该手机号。重启脚本
firstReg = true;
for i=1,10 do
	if firstReg then 
		toast("first Reg this phone",2);
	else --二次注册时重启微信
		run_app("com.tencent.xin",4000);
		toast('start weChat...');
		click_point(473, 1046,1000);--点击“注册”,等待注册界面启动；
		toast('choose China...',2);
		click_point(353, 300,2000)--点击进入选择地区列表；
		click_point(624, 912,2000)--点击M定位到中国地区；
		click_point(353, 915,2000)--点击中国
	end
		
	click_point(300,400,2000); --获取手机号输入框焦点
	local x, y = findImage("hasInputPhone.png", 0, 0, deviceX, deviceY); --验证失败点击关闭二次进入时会有手机号
	if (x ~= -1 and y ~= -1 ) then
		click_point(590,393,1000)
	end
	click_point(300,400,1000); --获取手机号输入框焦点

	inputText(mobileNo);--输入手机号码
	mSleep(2000);

	click_point(353,520,6000); --点击注册按钮

	while(true) do
		local x, y = findImage("agreement.png", 0, 0, deviceX, deviceY);
		if (x ~= -1 and y ~= -1 ) then
			toast('agreement page is opened.',1)
			click_point(577,1090,6000); --点击同意协议
			break
		end
		toast('waiting agreement page open...',1)
		mSleep(1000);
	end

	click_point(353,700,6000); --点击开始，进入滑块认证

	--等待滑块页面打开
	while(true) do
		local x, y = findImage("remove_page.png", 0, 0, deviceX, deviceY);
		if (x ~= -1 and y ~= -1 ) then
			toast('move page is opened.',2)
			mSleep(2000);
			aimx1,aimx2 = get_moveblock_position();						--计算滑块位置函数
			mSleep(1000)
			move_to(135,610,aimx1 + 45,610,6);
			mSleep(5000);
			--再找一次判断本次拖拽是否成功，不成功再来下一次
			local x1, y1 = findImage("remove_page.png", 0, 0, deviceX, deviceY);
			if (x1 == -1 and y1 == -1 ) then
				toast('滑块验证成功。',1)
				mSleep(2000);
				break
			end
		end
		mSleep(1000);
		toast('等待滑块页面打开...',1)
	end

	--滑块验证成功，进入辅助验证页面等待
	toast('开始辅助验证',1)
	mSleep(2000);

	--截取二维码保存在系统相册
	keepScreen(true);
	snapAndSave(20,660,400,1050);
	--截取二维码图片放在根目录的res文件中
	short_point_area_screen("verificationCode.png",20,660,400,1050);
	mSleep(2000)
	toast('已保存二维码',1)
	keepScreen(false);
	mSleep(1000)



	--[[*********************************************************
	--5分10秒内检测辅助结果：
		1.检测辅助成功： 上报辅助成功结果
		2.超时表明辅助失败： 上报辅助失败结果，点击关闭辅助界面，重新开始辅助
	--*********************************************************]]
	
	--首要要让人验证通过再去截图
	if firstReg then --手机号第一次验证的时候才检测，重复注册是
		--short_point_area_screen("checkSuccess.png",240,455,410,500)
		local checkSuccess = false; --验证状态
		for var= 1, 100 do
			local x, y = findImage("checkSuccess.png", 0, 0, deviceX, deviceY);
			if (x ~= -1 and y ~= -1 ) then
				firstReg = false;
				checkSuccess = true;
				toast("验证通过",2)
				--****发验证通过的通知***
				click_point(320,600,3000)
				ailezanSendMessage()
			end
			toast("暂未通过，waitting...",1)
			mSleep(3000)
		end
		if checkSuccess == false then
			--****发验证通过的通知***
			--点击关闭回到辅助验证等待
			click_point(160,80,3000) --点击关闭回到已输入手机号，点击注册界面
		end
	else
		--验证成功的二次注册直接发送短信
		toast("该手机号已通过辅助验证",1)
		mSleep(3000);
		ailezanSendMessage()
	end
end

toast("重取手机号开始脚本注册",1)
log_and_restart(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "该手机重试10次无效丢弃，冲去号注册");














