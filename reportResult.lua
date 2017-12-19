
function reportResult(baseUrl,recordId,result)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = baseUrl .. "/wc-register/assist-result";
	local data = "{\"recordId\":" .. recordId .. ",\"result\":" .. "\"" .. result .. "\"" .. "}";
	toast(data,10)
	mSleep(1000)
	require("TSLib");
	
	local successPost = false
	--for var= 1, 10 do
		toast("上报结果开始...",1)
		mSleep(2000)
		local result = httpPost(url, data);
		toast("上报结果结束...",1)
		mSleep(1000)
		if (type(result) ~= "string") then
			return false;
		end
		local resultStr = result:base64_decode();
		toast(resultStr,1)
		mSleep(2000)
		local resultTable = sz.json.decode(resultStr);
		if resultTable.returnCode == 100 then
			toast(resultTable.message,1);
			mSleep(2000)
			successPost = true;
			--break;
		else
			toast(resultTable.message,1);
			mSleep(2000)
		end
	--end
	--100次请求都没成功
	--if(successPost == false) then
		--log_and_restart('上报结果失败！');
	--end
	return successPost;
end

--reportResult("http://112.74.48.131:9090",12121820444540,"true")

