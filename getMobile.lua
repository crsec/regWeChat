function getMobile(aiLeZanToken)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.xingjk.cn/api/do.php?action=getPhone&token=" 
	url = url .. aiLeZanToken .. '&vno=0';
	local mobile = '';
	for num = 1, 10 do
		local res, code = http.request(url);
		nLog(res .. '|');
		nLog(code .. '|');
		if (code == 200) then
			local resultArr = string.split(res, "|");
			mobile = resultArr[2];
			break;
		else
			mSleep(3000);
		end
    end
	return mobile;
end
nLog('start to request phoneNum....');
phone = getMobile('de6c0e9d-acfc-4e5b-9a6f-6f6c461d7c40');
nLog(phone);

--'de6c0e9d-acfc-4e5b-9a6f-6f6c461d7c40'