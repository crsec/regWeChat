function getVcode(token)
	local sz = require("sz");
	local cjson = sz.json;
    local http = require("szocket.http");
	local url = "http://47.52.25.159/sms2/api/sms/getByToken?token=";
	url = url .. token;
	local vcode = nil;
	for num = 1, 10 do
		local res, code = http.request(url);
		nLog(res .. '|++++|' .. code);
		if (code == 200) then
			local data = cjson.decode(res);
			nLog(data);
			if data.flag == true then
				local msg = data.message;
				local start, last = string.find(msg, "(%d%d%d%d)");
				mSleep(5000)
				vcode = string.sub(msg,start,last);
				nLog(vcode);
				break;
			end
		else
			mSleep(3000);
		end
    end
	return vcode;
end