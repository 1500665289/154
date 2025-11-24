local XXZS_CS_D_01 = GameMain:GetMod("XXZS_CS_D_01");

-- 使用更简洁的方式定义ID数组
local ID = {
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
    1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,
    1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,
    1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,
    1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,
    2001,2002,2003,2004,2005,2006,2007,2008,3001,
    10001,10002,10003,10004
}

function XXZS_CS_D_01:GetID()
    -- 移除SetRandomSeed调用，通常只需要设置一次种子
    -- world:SetRandomSeed()
    
    -- 安全地生成随机索引（Lua数组索引从1开始）
    local idIndex = math.random(1, #ID)
    return ID[idIndex]
end

-- 或者如果确实需要me对象，可以这样定义：
function XXZS_CS_D_01:GetID(me)
    if not me then
        -- 如果没有传入me参数，使用默认的随机方法
        local idIndex = math.random(1, #ID)
        return ID[idIndex]
    else
        -- 使用me对象的随机方法
        local idIndex = me:RandomInt(1, #ID)
        return ID[idIndex]
    end
end

-- 或者更简单的版本：
function XXZS_CS_D_01:GetID()
    return ID[math.random(1, #ID)]
end