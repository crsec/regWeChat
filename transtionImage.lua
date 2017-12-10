
function downloadImg(imgUrl)
	local ts = require("ts");
	local linkFtpStatus = false;
	for var= 1, 300 do
		local status = ts.ftp.connect("111.111.11.151","username","password") 
		if status then
			toast("连接FTP成功",1)
			linkFtpStatus = true;
			break
		else
			toast("连接FTP失败", 2)
			mSleep(3000)
		end
	end
	if linkFtpStatus == false then
		log_and_exit(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "无法连接到FTP服务器");
	end

	--下载服务器上的文件到本地
	local downloadImgStatus = false;
	for var= 1, 300 do
		--path = userPath()
		local status = ts.ftp.download("/User/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/avatar.png",imgUrl,0)
		if status then
			toast("下载图片成功",1)
			downloadImgStatus = true;
			break
		else
			toast("下载图片失败", 2)
			mSleep(3000)
		end
	end
	if downloadImgStatus == false then
		log_and_exit(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "下载图片失败");
	end
	ts.ftp.close()  --操作完成后，断开FTP服务器连接
end


function uploadImg(imgUrl)
	local ts = require("ts");
	local linkFtpStatus = false;
	for var= 1, 300 do
		local status = ts.ftp.connect("111.111.11.151","username","password") 
		if status then
			toast("连接FTP成功",1)
			linkFtpStatus = true;
			break
		else
			toast("连接FTP失败", 2)
			mSleep(3000)
		end
	end
	if linkFtpStatus == false then
		log_and_exit(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "无法连接到FTP服务器");
	end

	--上传文件到服务器
	local uploadImgStatus = false;
	for var= 1, 300 do
		--path = userPath()
		local status = ts.ftp.upload("/User/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/erweima.png",imgUrl,0)
		if status then
			toast("上传图片成功",1)
			uploadImgStatus = true;
			break
		else
			toast("上传图片失败", 2)
			mSleep(3000)
		end
	end
	if uploadImgStatus == false then
		log_and_exit(logFileName, os.date("%Y-%m-%d %H:%M:%S") .. " " .. "上传图片失败");
	end
	ts.ftp.close()  --操作完成后，断开FTP服务器连接
end

	







--[[
local ts = require("ts");

toast("ceshi...",1)
mSleep(1000)
code,msg = ts.tsDownload("User/Media/PhotoData/Thumbnails/V2/DCIM/100APPLE/IMG_0072.PNG/1.jpg","http://p0.so.qhmsg.com/sdr/720_1080_/t01f0c2107148464d50.jpg")  
--同样支持ftp地址
--"1.jpg"（如只填文件名，默认保存到触动res目录下）
mSleep(8000);
toast("hhhhhh",1)
toast(code,1)
mSleep(1000)
dialog(msg,0)
mSleep(20000)



toast("asdfasdf",1)


--toast(8988888888,10)
--dialog(ts.version(), time)
--code,msg = ts.tsDownload("/var/1.jpg","http://qa-images.oss-cn-shenzhen.aliyuncs.com/20170926190732910.png") 
--toast(6666,1)
--同样支持ftp地址
--"1.jpg"（如只填文件名，默认保存到触动res目录下）
--toast(code,0)
--toast(msg,0)
require "TSLib"
toast(8989,1)
mSleep(1000)
webdata = httpGet("http://qnche-images.oss-cn-shenzhen.aliyuncs.com/20170904181159790.jpg")--获取百度首页网页数据
dialog("|" .. type(webdata) .. "|")


function getImg()
	local sz = require("sz");
    local http = require("szocket.http");
	local url = "http://qnche-images.oss-cn-shenzhen.aliyuncs.com/20170904181159790.jpg";
	--local url = "http://api.xingjk.cn/api/do.php?action=loginIn&name=18682386798&password=diandianchuxing";
	
	local token = nil;
	toast('start token',1)
	for num = 1, 10 do
		toast(26262626,1)
		local res, code = http.request(url);
		--toast(res..'|'..code,3)
		--toast(res,1)
		toast("|||"..code,1)
		if (code == 200) then
			local resultArr = string.split(res, "|");
			token = resultArr[2];
			break;
		else
			mSleep(3000);
		end
    end
	return token;
end
toast(6666,1)
mSleep(2000)
getImg()
toast(99999,2)
mSleep(2000)









--tsDownload


require("TSLib");
function updoadFile(filePath,url)
	os.execute("curl -F\"file=@" .. filePath .. "\"" .. url)
end
toast(1231313,1)
mSleep(3000)
--img = updoadFile("verificationCode.png","http://120.76.243.190:8090/qnche-admin/operate/uploadFile")
toast(999999,1)
mSleep(3000)
--toast(img,1)





function downdoadFile(filePath,url)
	code = os.execute("curl -o " .. filePath .. " " .. url);
	toast(code,1)
	mSleep(3000)
	toast(666666,1)
	mSleep(3000)
end

toast(33333,1)
mSleep(3000)
img = downdoadFile(userPath().."/res/verificationCode.png","http://qa-images.oss-cn-shenzhen.aliyuncs.com/20170915140722265.jpg")
toast(img,20)
toast(44444,1)
mSleep(3000)
toast(img,1)


]]