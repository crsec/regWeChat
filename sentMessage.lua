--提交短信内容和目的手机号到爱乐赞。，发送短信
function postMessage(token, sid, phone,message,recvPhone)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?action=putSentMessage";
	url = url .. "&phone=" .. phone .. "&sid=" .. "1017" .. "&message=" .. message .. "&recvPhone=" .. recvPhone .. "&token=" .. token;
	local postMessageStatus = false;
	for num = 1, 10 do
		local res, code = http.request(url);
		toast(res,1);
		mSleep(1000);
		toast(code,1)
		mSleep(1000)
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
				postMessageStatus = true;
		        wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "send message success.");
		        break;			
	        end
		end
		toast("post message failes",3)
		mSleep(3000);
    end
	return postMessageStatus;
end
--73612 --35366





--检测爱乐赞发送短信状态
function getMessageStatus(token, sid, phone)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?action=getSentMessageStatus";
	url = url .. "&phone=" .. phone .. "&sid=" .. "1017" .. "&token=" .. token;
	local getMessageStatus = false;
	for num = 1, 30 do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
				getMessageStatus = true;
		        wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "send message success.");
		        break;			
	        end
		end
		toast("send message failes",3)
		mSleep(3000);
    end
	return getMessageStatus;
end