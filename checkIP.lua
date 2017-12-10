function isIPAvailable(IPforChecking)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = "http://119.23.142.95:7001/card-pool-api/ip";
	local data = "{\"data\":" .. IPforChecking .. ",\"method\":\"add\"}";
	require("TSLib");
	local result = httpPost(url, data);
	toast('获取IP中...',1)
	if (type(result) ~= "string") then
		return false;
	end
	local resultStr = result:base64_decode();
	local resultTable = sz.json.decode(resultStr);
	return resultTable.success;
end



--请求检查IP地址是否可用
--1.可用，返回true和IP所属地区
--2.不可用，返回false重新开启关闭VPN
function checkIPAvailable(baseUrl,IPforChecking)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/ip-verify";
	local data = "{\"ipAddress\":" .. IPforChecking .. "}";
	--local data = "{\"ipAddress\":" .. IPforChecking .. ",\"method\":\"add\"}";
	require("TSLib");
	for var= 1, 100 do
		local result = httpPost(url, data);
		toast(result.message,1)
		if (result.returnCode == 100) then
			return result.data
			break
		else
			mSleep(1000);
		end
	end
	toast("检测Ip接口报错...",2)
	log_and_restart(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "该手机重试10次无效丢弃，冲去号注册");
end