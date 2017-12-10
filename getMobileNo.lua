
local DownLoad= class("DownLoad", cc.load("utils").Singleton)
local Log  = cc.load("utils").Log
local Http  = cc.load("net").Http

function DownLoad:DownLoadFile(url,fileName,callBack)
    Http:getInstance():DownloadFile(url,fileName,callBack)
end

function DownLoad:IsExitFile(fileName)
    local fullPath =  cc.FileUtils:getInstance():getWritablePath() .. "_download_/".. fileName
    if cc.FileUtils:getInstance():isFileExist(fullPath) then
        return fullPath
    else 
        return nil
    end   
end




require "TSLib"--使用本函数库必须在脚本开头引用并将文件放到设备 lua 目录下
require("baseMethods");
--delFile("/private/var/mobile/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/IMG_0072.PNG/5003.JPG") --删除test.txt文件，需要填写绝对路径
toast(userPath(),1)

short_point_area_screen("/private/var/mobile/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/IMG_0077.JPG/verificationCode.png",20,660,400,1050);
toast(88888,1)
mSleep(2000)

delFile(userPath().."/res/verificationCode.png") --删除test.txt文件，需要填写绝对路径
toast("success",1)


pSprite:retain()  -- a sprite
local xhr = cc.XMLHttpRequest:new()



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
		toast("get mobileNo failes",1)
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
	for num = 1, 10 do
		local res, code = http.request(url);
		toast(res .. "|" .. code,1)
		if (code == 200) then
			local resultArr = string.split(res, "|");
	        if(resultArr[1] == "1") then
		        curr_mobileNo = resultArr[2];
		        break;			
	        end
		end
		mSleep(3000);
    end
	return curr_mobileNo;
end
