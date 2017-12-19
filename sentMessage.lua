--提交短信内容和目的手机号到爱乐赞。，发送短信
function postMessage(token, sid, phone,message,recvPhone)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?action=putSentMessage";
	url = url .. "&phone=" .. phone .. "&sid=" .. sid .. "&message=" .. message .. "&recvPhone=" .. recvPhone .. "&token=" .. token;
	local postMessageStatus = false;
	while true do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
				postMessageStatus = true;
		        wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "post message success.");
		        break;			
	        end
		end
		toast(res,2)
		mSleep(3000);
    end
	return postMessageStatus;
end





--检测爱乐赞发送短信状态
function getMessageStatus(token, sid, phone)
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://api.hellotrue.com/api/do.php?action=getSentMessageStatus";
	url = url .. "&phone=" .. phone .. "&sid=" .. sid .. "&token=" .. token;
	local getMessageStatus = false;
	while true do
		local res, code = http.request(url);
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
				getMessageStatus = true;
		        wLog(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "send message success.");
		        break;			
	        end
		end
		toast("send message failes",2)
		mSleep(3000);
    end
	return getMessageStatus;
end