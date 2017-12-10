
--请求检查IP地址是否可用
--1.可用，返回true和IP所属地区
--2.不可用，返回false重新开启关闭VPN
function getRegResources(baseUrl,phoneNo)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/access-resources";
	local data = "{\"phoneNo\":" .. phoneNo .. "}";
	local regResources = {};
	require("TSLib");
	for var= 1, 100 do
		local result = httpPost(url, data);
		toast(result.message,1)
		if (result.returnCode == 100) then
			regResources["recordId"] = result.data.recordId;
			regResources["nickname"] = result.data.nickname;
			regResources["password"] = result.data.password;
			regResources["avatarUrl"] = result.data.avatarUrl;
			regResources["momentsPicUrl"] = result.data.momentsPicUrl;
			regResources["momentsMsg"] = result.data.momentsMsg;
			break;
		else
			toast("请求资源错误！",2);
			mSleep(3000);
		end
		--100次请求都没成功
		if(successPost == false) then
			log_and_restart('请求注册资源失败！');
		end
	end
	return regResources;
end


