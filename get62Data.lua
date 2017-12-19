	
function get62Data(mobileNo,nickname,password)
	require("TSLib");
	local sz = require("sz");
	local json = sz.json
	http = require("szocket.http")
	
	local path=appDataPath("com.tencent.xin")
	if path then
		path=path:gsub("/Documents","").."/Library/WechatPrivate/wx.dat"
	else
		return false,"app null"
	end
	
	local file=io.open(path,"r")
	local ret = nil;
	if file then
		ret=file:read("*a"):tohex()
		file:close()
		--提取出来保存到  /var/mobile/Media/TouchSprite/lua/提取62.txt
		--按格式保存      账号.."----"..密码.."----"..转换出来的62数据.."----"
		writeFileString("/var/mobile/Media/TouchSprite/lua/提取62.txt",mobileNo .. "----" .. password.."----"..ret.."----\r\n","a")
		return ret
	else
		error("请输入正确的wx.dat地址",2)
		return ret
	end
end
