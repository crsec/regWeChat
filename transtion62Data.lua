


function transtion62Data(baseUrl,recordId,sessonKey,weChatId)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = baseUrl .. "/wc-register/assist-data";
	local data = "{\"recordId\":" .. recordId .. ",\"sessonKey\":" .. "\"" .. sessonKey .. "\"" .. ",\"weChatId\":" .. "\"" .. weChatId .. "\"" .. "}";
	local getData = {};
	require("TSLib");

	local successPost = false
	for var= 1, 100 do

		toast("上传62数据开始...",1)
		mSleep(1000)
		local result = httpPost(url, data);
		if (type(result) ~= "string") then
			--return false;
			toast("服务器异常，请检查...",1)
			mSleep(1000)
		end
		local resultStr = result:base64_decode();
		local resultTable = sz.json.decode(resultStr);
		if resultTable.returnCode == 100 then
			toast(resultTable.message,1);
			successPost = true;
			break;
		else
			toast("上传62数据错误！",2);
			mSleep(3000);
		end
	end
	--100次请求都没成功
	if(successPost == false) then
		log_and_restart('上传62数据失败！');
	end
	return successPost;
end
--transtion62Data("http://112.74.48.131:9090",12121820444540,"62706c6973743030d40102030405080b0c5424746f7058246f626a65637473582476657273696f6e59246172636869766572d1060754726f6f748001a2090a55246e756c6c5f1020303738393834366334323831396631663961636332336566323638333834653912000186a05f100f4e534b6579656441726368697665720811161f2832353a3c3f45686d0000000000000101000000000000000d0000000000000000000000000000007f13234757330")

