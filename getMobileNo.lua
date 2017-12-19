
--自获取手机号，没有城市限制
function getMobileNo(token, sid)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?";
	url = url .. "action=getPhone" .. "&sid=" .. sid .. "&token=" .. token;
	local curr_mobileNo = nil;
	for num = 1, 10 do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
				toast("get mobileNo success",1)
		        curr_mobileNo = resultArr[2];
		        break;			
	        end
		end
		toast(res,2)
		mSleep(3000);
    end
	return curr_mobileNo;
end

--自获指定城市取手机号
function getCityMobileNo(token, sid, city)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?";--"http://api.hellotrue.com/api/do.php?";
	url = url .. "action=getPhone" .. "&sid=" .. sid .. "&token=" .. token .. "&locationLevel=c" .."&location=" .. city;
	local curr_mobileNo = nil;
	while true do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
		        curr_mobileNo = resultArr[2];
		        break;			
	        end
		end
		toast(res,2)
		mSleep(3000);
    end
	return curr_mobileNo;
end

--手机号加入黑名单
function addBlacklist(token, sid, phone)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?";--"http://api.hellotrue.com/api/do.php?";
	url = url .. "action=addBlacklist" .. "&sid=" .. sid .. "&token=" .. token .."&phone=" .. phone;
	local optionSuccess = false;
	for num = 1, 10 do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
		        optionSuccess = true
		        break;			
	        end
		end
		mSleep(3000);
    end
	toast(res,2)
	return optionSuccess;
end
