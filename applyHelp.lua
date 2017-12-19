

require("TSLib");
require("baseMethods");

--截取指定区域的图片  开发时使用
--short_point_area_screen("tryAgain.png",280,800,365,850)
--short_point_area_screen("voice_btn.png",270,930,356,910)
--short_point_area_screen("voice_next_btn.png",254,940,390,980)
--short_point_area_screen("learn_more.png",115,685,250,725)
--short_point_area_screen("search_friend_good.png",430,690,480,720)
--short_point_area_screen("remont_and_enter.png",180,940,460,990)
--short_point_area_screen("notAddFriend_hao.png",290,670,350,710)
--short_point_area_screen("have_know.png",265,735,380,780)
--short_point_area_screen("password_unused_sure.png",280,645,360,685)
--short_point_area_screen("not_have_SIM.png",210,510,435,555)
--short_point_area_screen("phone_had_reged.png",40,425,510,500)
--short_point_area_screen("agreement.png",540,1070,615,1105,95)
--short_point_area_screen("reg_btn_green.png",140,485,500,550)
--short_point_area_screen("begin_reg_btn_green.png",235,680,380,730)

--short_point_area_screen("to_send_msg_btn.png",200,725,440,775)
--short_point_area_screen("vpn_link_fail.png",240,470,410,580)

--short_point_area_screen("allpy_user_voice.png",120,470,515,510)
--short_point_area_screen("allpy_use_mail_list.png",120,453,515,495)
--short_point_area_screen("allpy_use_photo.png",140,470,495,510)
--short_point_area_screen("agreement.jpg",540,1070,615,1105,1)
--short_point_area_screen("has_choosed_china.png",180,280,265,330)

--toast(9999,1)


function applyHelp(baseUrl,recordId,qrPicUrl)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = baseUrl .. "/wc-register/apply-assist";
	local data = "{\"recordId\":" .. recordId .. ",\"qrPicUrl\":" .. "\"" .. qrPicUrl .. "\"" .. "}";
	require("TSLib");
	
	local successPost = false;
	for var= 1, 100 do
		toast("申请辅助...",1)
		mSleep(1000)
		local result = httpPost(url, data);
		
		if (type(result) ~= "string") then
			--return false;
			toast("服务器异常，请检查...",1)
			mSleep(1000)
		end
		local resultStr = result:base64_decode();
		local resultTable = sz.json.decode(resultStr);
		
		if resultTable.returnCode == 100 then
			toast(resultTable.message,1);
			successPost = true;
			break;
		else
			toast(resultTable.message,2);
			mSleep(3000);
		end
	end
	--3次请求都没成功
	--if(successPost == false) then
		--log_and_restart('申请辅助失败！');
	--end
	return successPost;
end

--applyHelp("http://112.74.48.131:9090",12121801178266,"ftp://112.74.48.131:213/qr-pic/DqMZgE15130674478215.png")

