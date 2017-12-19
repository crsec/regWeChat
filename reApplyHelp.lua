
function reApplyHelp(baseUrl,lastTimeRecordId,qrPicUrl)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/r-apply-assist";
	local data = "{\"lastTimeRecordId\":" .. lastTimeRecordId .. ",\"qrPicUrl\":" .. "\"" .. qrPicUrl .. "\"" .. "}";
	local getData = {};
	require("TSLib");
	
	local successPost = false
	for var= 1, 100 do
		toast("再次申请辅助开始...",1)
		mSleep(2000)
		local result = httpPost(url, data);
		
		if (type(result) ~= "string") then
			--return false;
			toast("服务器异常，请检查...")
			mSleep(2000)
		end
		local resultStr = result:base64_decode();
		local resultTable = sz.json.decode(resultStr);
		if resultTable.returnCode == 100 then
			toast(resultTable.message);
			successPost = true;
			getData["recordId"] = resultTable.data.recordId;
			getData["nickname"] = resultTable.data.nickname;
			getData["password"] = resultTable.data.password;
			getData["avatarUrl"] = resultTable.data.avatarUrl;
			getData["momentsPicUrl"] = resultTable.data.momentsPicUrl;
			getData["momentsMsg"] = resultTable.data.momentsMsg;
			break;
		else
			toast("再次申请辅助错误！",2);
			mSleep(3000);
		end
	end
	--100次请求都没成功
	if(successPost == false) then
		--log_and_restart('再次申请辅助失败！');
		return successPost
	else
		return getData;
	end
	
end

--getData = reApplyHelp("http://112.74.48.131:9090",12121801178266,"ftp://112.74.48.131:213/qr-pic/DqMswE15130674478215.png")
--toast(type(getData),1)