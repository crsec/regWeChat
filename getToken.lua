function getToken()
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.xingjk.cn/api/do.php?action=loginIn&name=api-9ax7vsgf&password=diandianchuxing";
	--local url = "http://api.xingjk.cn/api/do.php?action=loginIn&name=18682386798&password=diandianchuxing";
	
	local token = nil;
	toast('start token',1)
	for num = 1, 10 do
		local res, code = http.request(url);
		toast('获取Token中...'..'|'..code,1)
		if (code == 200) then
			local resultArr = string.split(res, "|");
			token = resultArr[2];
			toast(token,1)
			break;
		else
			mSleep(3000);
		end
    end
	return token;
end
--[[
用户名：ynch1
密码：5648
套餐：全国随机
到期时间:2017/12/9 17:00:18
服务器地址：yy.dtpptp.com 

用户名：ynch2
密码：5648
套餐：全国随机
到期时间:2017/12/9 17:00:18
服务器地址：yy.dtpptp.com 

用户名：ynch3
密码：5648
套餐：全国随机
到期时间:2017/12/9 17:00:18
服务器地址：yy.dtpptp.com 

用户名：ynch4
密码：5648
套餐：全国随机
到期时间:2017/12/9 17:00:18
服务器地址：yy.dtpptp.com 

用户名：ynch5
密码：5648
套餐：全国随机
到期时间:2017/12/9 17:00:18
服务器地址：yy.dtpptp.com
]]