
--请求检查IP地址是否可用
--1.可用，返回true和IP所属地区
--2.不可用，返回false重新开启关闭VPN

require("TSLib");
function getRegResources(baseUrl,phoneNo,ipAddress,city)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/access-resources";
	local data = "{\"phoneNo\":" .. "\"" .. phoneNo .. "\"" .. ",\"ipAddress\":" .. "\"" .. ipAddress .. "\"" .. ",\"registerCity\":" .. "\"" .. city .. "\"" ..  "}";
	local regResources = {};
	local successPost = false;
	for var= 1, 100 do
		toast("请求注册资源开始...",1)
		mSleep(1000)
		local result = httpPost(url, data);
		if (type(result) ~= "string") then
			--return false;
			toast("服务器异常，请检查...")
			mSleep(2000)
		else
			local resultStr = result:base64_decode();
			local resultTable = sz.json.decode(resultStr);
			
			if resultTable.returnCode == 100 then
				toast(resultTable.message);
				successPost = true;
				regResources["recordId"] = resultTable.data.recordId;
				regResources["nickname"] = resultTable.data.nickname;
				regResources["password"] = resultTable.data.password;
				regResources["avatarUrl"] = resultTable.data.avatarUrl;
				regResources["momentsPicUrl"] = resultTable.data.momentsPicUrl;
				regResources["momentsMsg"] = resultTable.data.momentsMsg;
				break;
			else
				toast("请求注册资源错误！",2);
				mSleep(3000);
			end
		end
	end
	--100次请求都没成功
	if(successPost == false) then
		log_and_restart('请求注册资源失败！');
	end
	return regResources;
end

--regResources = getRegResources("http://112.74.48.131:9090","18356987458","192.168.0.104","苏州");
--toast(type(regResources),1)


