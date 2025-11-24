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

function tbTable:QH(attrCS, attrMin, attrMax, attrAddv, attrAddp)
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
        '_FlyFabaoEnd'
    };
    
    -- 增加空值检查
    if attrCS == nil or attrMin == nil or attrMax == nil then
        world:ShowMsgBox('强化参数错误！')
        return
    end
    
    local myNpc = world:GetSelectThing();
    if myNpc == nil then
        world:ShowMsgBox('没有选中NPC！')
        return
    end
    
    local fabao = myNpc:GetFirstAtkFabao();
    if fabao == nil or fabao.Fabao == nil then
        world:ShowMsgBox('NPC没有装备法宝！')
        return
    end
    
    local attr = fabao.Fabao:GetProperty(attrCS);
    local attrCSStr = tostring(attrCS);
    local index = tonumber(string.match(attrCSStr, "%d+"));
    
    -- 增加索引范围检查
    if index == nil or index < 0 or index >= #attrStrList then
        world:ShowMsgBox('属性类型错误！')
        return
    end
    
    local attrStr = attrStrList[index + 1] or '未知属性';
    
    if attr <= attrMax and attr >= attrMin then
        local value = attr;
        
        -- 改进数值计算逻辑
        if attrAddv ~= nil and attrAddv > 0 then
            value = attr + attrAddv;
        elseif attrAddp ~= nil and attrAddp > 0 then
            value = attr + attr * attrAddp;
        else
            world:ShowMsgBox('强化参数错误！请提供有效的强化值或百分比。')
            return
        end
        
        -- 限制最大值，防止溢出
        if value > attrMax then
            value = attrMax
        end
        
        fabao.Fabao:SetProperty(attrCS, value);
        
        -- 格式化显示数值
        local beforeValue = math.ceil(attr * 100) / 100  -- 保留2位小数
        local afterValue = math.ceil(value * 100) / 100
        
        world:ShowMsgBox('法宝的 [color=#FF0000]'..attrStr..'[/color] 强化完成\n'..
                        '强化前: '..tostring(beforeValue)..'\n'..
                        '强化后: '..tostring(afterValue));
    else
        world:ShowMsgBox('法宝的'..attrStr..'属性异常！\n'..
                        '当前值: '..tostring(math.ceil(attr * 100) / 100)..'\n'..
                        '限制范围: '..tostring(attrMin)..' - '..tostring(attrMax));
    end
end

--[[
local attrCS = CS.XiaWorld.Fight.g_emFaBaoP.AttackPower;
GameMain:GetMod("XXZS_QH"):QH(attrCS,1,800,0,0.1);
GameMain:GetMod("XXZS_QH"):QH(attrCS,1,800,100,0);
--]]