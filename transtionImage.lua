


function safariDownloadImg(ftpUrl,imgType)
	local downAvatarUrl = "ftp://weixing:weixing@" .. string.sub(ftpUrl, 7, string.len(ftpUrl));
	
	click_point(320, 80,5000)
	for var= 1, 3 do
		local x, y = findImage("safari_input.png", 0, 0, 10000, 10000);
		if (x ~= -1 and y ~= -1 ) then
			touchDown(x+17, y+12);
			mSleep(67);
			touchUp(x+17, y+12);
			mSleep(2000);
			break
		end
	end
	if imgType == "avatarImg" then
		for var= 1, 3 do
			local x, y = findImage("safari_input.png", 0, 0, 10000, 10000);
			if (x ~= -1 and y ~= -1 ) then
				touchDown(x+17, y+12);
				mSleep(67);
				touchUp(x+17, y+12);
				mSleep(2000);
				break
			end
		end
	end
		
	mSleep(1000)
	inputText(downAvatarUrl);--输入图片地址
	mSleep(2000);
	click_point(590, 1100,8000) -- 点击GO
	
	touchDown(320, 150)
	mSleep(3000);
	touchUp(40, 150)
	click_point(320, 880,8000) -- 点击下载到本地(8秒)
end


function downloadImg(localPath,ftpUrl)
	local ts = require("ts");
	local linkFtpStatus = false;
	for var= 1, 300 do
		local status = ts.ftp.connect("112.74.48.131:213","weixing","weixing") 
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
		toast("下载图片中...",4)
		local status = ts.ftp.download(localPath,ftpUrl,0)
		toast(66666,2)
		mSleep(2000)
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

--downloadImg(path,"ftp://112.74.48.131:213/qr-pic/eIvKVN15130438123720.png")




function uploadImg(localPath,ftpPath)
	
	local ts = require("ts");
	local linkFtpStatus = false;
	for var= 1, 10 do
		local status = ts.ftp.connect("112.74.48.131:213","weixing","weixing") 
		toast(status,1)
		mSleep(2000)
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
		toast("上传图片中...",4)
		local status = ts.ftp.upload(localPath,ftpPath,0)
		if status then
			toast("上传图片成功",1)
			mSleep(3000)
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


--uploadImg(userPath() .. "/res/remove_page.png",qrCodePath)
--toast(66666,1)
--mSleep(2000)

