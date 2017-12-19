

function checkIPAvailable(baseUrl,IPforChecking)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/ip-verify";
	local data = "{\"ipAddress\":" .. "\"" .. IPforChecking .. "\"" .. "}";
	local getData = {};
	
	require("TSLib");
	
	local successPost = false
	for var= 1, 100 do
		toast("checkIp...",1)
		local result = httpPost(url, data);
		if (type(result) ~= "string") then
			--return false;
			toast("服务器异常，请检查...",1)
			mSleep(4000)
		else
			local resultTable = result:base64_decode();
			local resultTable = sz.json.decode(resultTable);
			if resultTable.returnCode == 100 then
				toast(resultTable.message,1);
				mSleep(1000)
				successPost = true;
				getData["recommend"] = resultTable.data.recommend;
				getData["area"] = resultTable.data.area;
				getData["location"] = resultTable.data.location;
				break;
			else
				toast("检查IP错误！",2);
				mSleep(3000);
			end
		end
	end
	--100次请求都没成功
	if(successPost == false) then
		log_and_exit('服务器异常，检查IP地址失败！');
	end
	return getData;
end
--checkDate = checkIPAvailable("http://112.74.48.131:9090","220.186.188.184");
--toast(type(checkDate),1)


