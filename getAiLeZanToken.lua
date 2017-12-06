function getAiLeZanToken()
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.xingjk.cn/api/do.php?action=loginIn&name=api-9ax7vsgf&password=diandianchuxing";
	
	local mobileInfo = '';
	for num = 1, 10 do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
			mobileInfo = resultArr[2];
			break;
		else
			mSleep(3000);
		end
    end
	return mobileInfo;
end