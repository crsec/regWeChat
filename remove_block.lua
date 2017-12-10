--滑块解锁
local is_left_edge = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x - 1, y)
	if r+g+b > 190 * 3 and r1+g1+b1 < 330 then
		return true
	end
		return false
end

local is_right_edge = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x + 1, y)
	if r+g+b > 190 * 3 and r1+g1+b1 < 330 then
		return true
	end
		return false
end

local is_top_edge = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x, y - 1)
	if r+g+b > 190 * 3 and r1+g1+b1 < 330 then
		return true
	end
		return false
end

local is_buttom_edge = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x, y + 1)
	if r+g+b > 190 * 3 and r1+g1+b1 < 330 then
		return true
	end
		return false
end



local is_left_edge_2 = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x + 86, y)
	if r+g+b < 300 and r1+g1+b1 < 300 then
		return true
	end
		return false
end

local is_top_edge_2 = function (x,y)
	local r,g,b = getColorRGB(x, y);
	local r1,g1,b1 = getColorRGB(x, y + 86)
	if r+g+b < 330 and r1+g1+b1 < 330 then
		return true
	end
		return false
end

local getPosition = function()
	keepScreen(true)
	for i= 232, 509 do
		if is_left_edge_2(92,i) and is_right_edge(179,i) and is_top_edge(92,i) then
			keepScreen(false)
			return i
		end
	end
	keepScreen(false)
	return false
end




local getPosition_2 = function(y)
	keepScreen(true)
	for i= 170, 522 do
		if is_left_edge_2(i,y) then
			for j= 1, 25 do
				if (not is_left_edge_2(i,y+j)) or (not is_left_edge_2(i,y+60+j)) or (not is_top_edge_2(i+j,y)) or (not is_top_edge_2(i+j+60,y)) then
					break
				end
				if j == 25 then
					keepScreen(false)
					return i
				end
			end
		end
	end
	keepScreen(false)
	return false
end





slider = {}
slider.action = function ()
	local y = getPosition()
	nLog(y);
	nLog(66666);
	if y then
		local x = getPosition_2(y)
		nLog(x);
		nLog(77777);
		if x then
			touch.on(100,620) :move(x,620) :off()
			return true;
		else
			toast('未找到凹陷部分',1)
			return false
		end
	else
		toast('未找到模板方块',1)
		return false
	end
end

--return slider



--[[
        触摸找到微信滑动验证码碎片及插槽算法示例.lua

        感谢原作者苏泽，修改Evan

        请勿用于商业用途！！！

        原理：
                碎片左上角是黑线下面为高光边缘，制造一个这样的折角点色阵然后用找色函数找到它
                找到碎片后，使用暗化函数处理找到的位置区域中的点色生成一个点色阵，在平行范围中找到它

                注：以下示例中用到的颜色及色偏是目测的，没有精确调整，细节优化自己做

        封装说明：
                ps = find_piece_slot{
                        rect = {30, 232, 610, 563};             -- 整个验证码的区域
                        piece_side = 90;                        -- 碎片方块边长
                        piece_start_rect = {60, 240, 105, 490}; -- 碎片方块查找区域
                }

                如果没找到 ps 返回 nil
                找到 ps 为这样的结构：
                {
                        piece = {x, y};
                        slot  = {x, y};
                }

--]]


function find_piece_slot(info)
        local function darken(c)
                local r, g, b = (c / 0x10000), ((c % 0x10000) / 0x100), (c % 0x100)
                r, g, b = math.floor(r * 0.36), math.floor(g * 0.4), math.floor(b * 0.4)
                return r * 0x10000 + g * 0x100 + b
        end
        local math_floor = math.floor
        local p = {0, 0}
        info.piece_side = math_floor(info.piece_side)
        --[[ 以后颜色有变化修改此处代码就可以。就别再问我要了
                下面就是取色的例子，0x555555代表灰，0xffffff代表白

                灰灰灰灰灰灰灰灰灰灰灰
                灰白白白白白白白白白白
                灰白
                灰白
                灰白
                灰白
                灰白
                灰白
                灰白
                灰白
                灰白

        local pcs = {
                {p[1], p[2], {0x555555, 0x555555}}
        }
        for i=1, math_floor(info.piece_side/9) do
                pcs[#pcs + 1] = {p[1] + i, p[2], {0x555555, 0x555555}}
                pcs[#pcs + 1] = {p[1], p[2] + i, {0x555555, 0x555555}}
                pcs[#pcs + 1] = {p[1] + i, p[2] + 1, {0xffffff, 0x5f5f5f}}
                pcs[#pcs + 1] = {p[1] + 1, p[2] + i, {0xffffff, 0x5f5f5f}}
        end

        这次更新后灰色边框基本无变化，白色变成了黄色，所以更改如下
                灰灰灰灰灰灰灰灰灰灰灰
                灰黄黄黄黄黄黄黄黄黄黄
                灰黄
                灰黄
                灰黄
                灰黄
                灰黄
                灰黄
                灰黄
                灰黄
                灰黄
        ]]
        local pcs = {
                {p[1], p[2], {0x505050, 0x505050}}
        }
        for i=1, math_floor(info.piece_side/9) do
                pcs[#pcs + 1] = {p[1] + i, p[2], {0x505050, 0x505050}}
                pcs[#pcs + 1] = {p[1], p[2] + i, {0x505050, 0x505050}}
                pcs[#pcs + 1] = {p[1] + i, p[2] + 1, {0xf0f0b0, 0x5f5f5f}}
                pcs[#pcs + 1] = {p[1] + 1, p[2] + i, {0xf0f0b0, 0x5f5f5f}}
        end
        keepScreen(true);
        local piece_x, piece_y = find_color(pcs,table.unpack(info.piece_start_rect))
        if piece_x == -1 then
                --("查找验证码框失败")
                keepScreen(false);
                return nil
        else
                --(string.format("找到验证码框x=%s,y=%s",piece_x, piece_y ))
        end

        pcs = {}
        local center_dist = math_floor(info.piece_side * 0.256)
        for i=1, math_floor(info.piece_side/3) do
                pcs[#pcs + 1] = {piece_x + center_dist + i, piece_y + center_dist + i, darken(getColor(piece_x + center_dist + i, piece_y + center_dist + i))}
        end
        local slot_x, slot_y = -1, -1
        for i=1, math_floor(info.piece_side/3) do
                slot_x, slot_y = find_color2(pcs, 99 - i, piece_x, piece_y, info.rect[3], piece_y + info.piece_side)
                if (slot_x ~= -1) then
                        slot_x, slot_y = slot_x - center_dist, slot_y - center_dist
                        break
                else
                        --logDebug(string.format("循环%s次",i))
                end
        end
        keepScreen(false);

        if slot_x > 0 then
                return {
                        piece = {piece_x, piece_y};
                        slot = {slot_x, slot_y};
                }
        else
                --("查找移动范围失败")
                return nil
        end
end
function find_color(t,x1,y1, x2, y2)--找色
        local x,y,c;
        local r,g,b;
        local flag;
        y = y1;
        for i=1,y2-y1 do
                x = x1;
                for ii=1,x2-x1 do
                        flag = true;
                        for iii = 1 , #t do
                                if mcolor(x+t[iii][1],y+t[iii][2],t[iii][3][1],t[iii][3][2]) then
                                else
                                        flag = false;
                                        break;
                                end
                        end
                        if flag then
                                return x,y,true;
                        end
                        x = x + 1;
                end
                y = y + 1;
        end
        return -1,-1,false;
end
function find_color2(t,sim, x1,y1, x2, y2)--找色
        local x,y,c;
        local r,g,b;
        local flag;
        y = y1;
        for i=1,y2-y1 do
                x = x1;
                for ii=1,x2-x1 do
                        flag = true;
                        for iii = 1 , #t do
                                if iii == 1 then
                                        if mcolor2(x,y,t[iii][3],sim) then
                                        else
                                                flag = false;
                                                break;
                                        end
                                else
                                        if mcolor2(x+t[iii][1]-t[1][1],y+t[iii][2]-t[1][2],t[iii][3],sim) then
                                        else
                                                flag = false;
                                                break;
                                        end
                                end
                        end
                        if flag then
                                return x,y,true;
                        end
                        x = x + 1;
                end
                y = y + 1;
        end
        return -1,-1,false;
end
function mcolor(x1,y1,c,n)
        r, g, b = getColorRGB(x1,y1);
        ra, ga, ba = math.floor((c / 0x10000)), math.floor(((c % 0x10000) / 0x100)), math.floor((c % 0x100))
        rn, gn, bn = math.floor((n / 0x10000)), math.floor(((n % 0x10000) / 0x100)), math.floor((n % 0x100))
        if math.abs(r-ra)<=rn and math.abs(g-ga)<=rn and math.abs(b-ba)<=rn then
                return true
        else
                return false
        end
end
function mcolor2(x1,y1,c,n)
        n=255-255*n/100
        r, g, b = getColorRGB(x1,y1);
        ra, ga, ba = math.floor((c / 0x10000)), math.floor(((c % 0x10000) / 0x100)), math.floor((c % 0x100))
        if math.abs(r-ra)<=n and math.abs(g-ga)<=n and math.abs(b-ba)<=n then
                return true
        else
                return false
        end
end
key = ""
function PrintTable(table , level)
  level = level or 1
  local indent = ""
  for i = 1, level do
    indent = indent.."  "
  end

  if key ~= "" then
    --(indent..key.." ".."=".." ".."{")
  else
    --(indent .. "{")
  end

  key = ""
  for k,v in pairs(table) do
     if type(v) == "table" then
        key = k
        PrintTable(v, level + 1)
     else
        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
      --(content)
      end
  end
  --(indent .. "}")
end
-- 以上是封装好的函数，以下是例子

function get_moveblock_position()
        toast("滑块脚本开始",1)
        mSleep(1000)
        info={
            rect = {30, 232, 610, 563};             -- 整个验证码的区域
            piece_side = 90;                        -- 碎片方块边长
            piece_start_rect = {60, 240, 105, 490}; -- 碎片方块查找区域
        }
        local ps = find_piece_slot(info)
        if type(ps)=="table" then
            PrintTable(ps)
			toast('计算位置成功');
			return ps.slot[1],ps.slot[2]
        else
            toast("查找滑块位置失败",1);
			mSleep(3000);
			get_moveblock_position()
        end
end

return get_moveblock_position








