local tbTable = GameMain:GetMod("XXZS_QH");
--attrStrList 依次对应为以下项目
--[[
		None,
		AttackPower,
		LingRecover,
		MaxLing,
		FlySpeed,
		RotSpeed,
		KnockBackAddition,
		KnockBackResistance,
		Scale,
		TailLenght,
		AttackRate,
		_FightFabaoEnd,
		MoveSpeed,
		_FlyFabaoEnd
--]]

function tbTable:QH(attrCS,attrMin,attrMax,attrAddv,attrAddp)

	--*具体名称，请参考游戏内的称呼进行修改
	local attrStrList = {
	'None',
	'法宝威力',
	'回灵速度',
	'最大灵气',
	'飞行速度',
	'回旋速度',
	'击退强度',
	'击退抵抗',
	'大小',
	'拖尾长度',
	'攻击间隔',
	'_FightFabaoEnd',
	'移动速度',
	'_FlyFabaoEnd'};
	local myNpc = world:GetSelectThing();
	local fabao = myNpc:GetFirstAtkFabao();
	if fabao ~=nil then
		local attr = fabao.Fabao:GetProperty(attrCS);
		local attrCSStr = tostring(attrCS);
		local index = tonumber(string.match(attrCSStr,"%d+"));
		local attrStr = (attrStrList[index+1]);
		
		if attr <=attrMax and attr >=attrMin then
			local value = attr;
			if attrAddv ~=nil and attrAddv > 0 then
				value = attr + attrAddv;
			else
				value = attr + attr*attrAddp;
			end
			fabao.Fabao:SetProperty(attrCS,value);
			world:ShowMsgBox('法宝的 [color=#FF0000]'..attrStr..'[/color] 强化完成\n'..'强化前'..math.ceil(attr)..'\n'..'强化后'..math.ceil(value));
		else
			world:ShowMsgBox('法宝的'..attrStr..'属性异常！\n限制为 最高'..tostring(attrMax)..' 最低'..tostring(attrMin));
		end
	else
		world:ShowMsgBox('NPC没有装备法宝！')
	end
end

--[[
local attrCS = CS.XiaWorld.Fight.g_emFaBaoP.AttackPower;
GameMain:GetMod("XXZS_QH"):QH(attrCS,1,800,0,0.1);
GameMain:GetMod("XXZS_QH"):QH(attrCS,1,800,100,0);
-]]
