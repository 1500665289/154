local XiaoQi = GameMain:GetMod("XiaoQi");

function XiaoQi:OnAfterLoad()
    -- 移除未使用的file变量
    local ModPaths = XiaoQi:GetPaths("Settings/Ui/Help/Help.xml");
    for k, v in pairs(ModPaths) do
        local PathData = v;
        local text = CS.GFileUtil.ReadTXT(PathData, true);
        if text == nil or text.Length == 0 then
            break;
        end
        local xmlSerializer = CS.System.Xml.Serialization.XmlSerializer(typeof(CS.XiaWorld.UIHelpDefs));
        local uihelpDefs = xmlSerializer:Deserialize(CS.System.IO.StringReader(text));
        if uihelpDefs ~= nil then
            XiaoQi:LoadHelp(uihelpDefs)
        end
    end
end

function XiaoQi:LoadHelp(defs)
    if defs == nil or defs.Datas == nil then
        return
    end
    
    xlua.private_accessible(CS.XiaWorld.UILogicMgr);
    local uiLogicMgr = CS.XiaWorld.UILogicMgr.Instance
    if uiLogicMgr == nil or uiLogicMgr.mapHelpData == nil then
        return
    end
    
    -- 使用ipairs确保顺序遍历，避免非连续索引问题
    for i = 0, defs.Datas.Count - 1 do
        local uihelpDef = defs.Datas[i]
        if uihelpDef ~= nil and uihelpDef.Name ~= nil then
            if uiLogicMgr.mapHelpData:ContainsKey(uihelpDef.Name) then
                uiLogicMgr.mapHelpData:Remove(uihelpDef.Name);
            end
            uiLogicMgr.mapHelpData:Add(uihelpDef.Name, uihelpDef);
        end
    end
end

function XiaoQi:GetPaths(filepath)
    local list = {}
    local Mods = CS.ModsMgr.Instance.Mods
    if Mods == nil then
        return list
    end
    
    for k, v in pairs(Mods) do
        if v.IsActive then
            local path2 = v.Path .. "/" .. filepath;
            if CS.System.IO.File.Exists(path2) then
                table.insert(list, path2)
            end
        end
    end
    return list;
end

function XiaoQi:OnEnter()
    if CS.Wnd_Help.Instance == nil then
        return
    end
    
    CS.Wnd_Help.Instance:Show();
    CS.Wnd_Help.Instance:Hide();
    
    if CS.Wnd_Help.Instance.contentPane ~= nil and 
       CS.Wnd_Help.Instance.contentPane.m_Text ~= nil and 
       CS.Wnd_Help.Instance.contentPane.m_Text.m_title ~= nil then
        CS.Wnd_Help.Instance.contentPane.m_Text.m_title.onClickLink:Add(XiaoQi.onClickLink); 
    end
end

function XiaoQi.onClickLink(Context)
    if Context == nil or Context.data == nil then
        return
    end
    
    local link = Context.data;
    if string.find(link, "http://") or string.find(link, "https://") then
        CS.UnityEngine.Application.OpenURL(Context.data)
    end
    if string.find(link, "tencent://") and CS.System.Diagnostics.Process.GetProcessesByName("QQ").Length > 0 then
        CS.UnityEngine.Application.OpenURL(Context.data)
    end
end

function XiaoQi:ShowHelp(Context)
    if CS.Wnd_Help.Instance == nil then
        return
    end
    
    CS.Wnd_Help.Instance:Show();
    local list = CS.Wnd_Help.Instance.contentPane.m_menu;
    if list ~= nil then
        for i = 0, list.numChildren - 1 do
            local item = list:GetChildAt(i);
            if item ~= nil and item.m_n19 ~= nil and item.m_n19.data == "XiaoQi_Main" then
                item.m_n19.onClick:Call();
            end
        end
    end
    
    -- 修正UILogicMgr引用
    local helpDef = CS.XiaWorld.UILogicMgr.Instance:GetHelpDef("XiaoQi_1");
    if helpDef ~= nil and CS.Wnd_Help.Instance.contentPane.m_Text ~= nil then
        CS.Wnd_Help.Instance.contentPane.m_Text.text = helpDef.Text;
        if CS.Wnd_Help.Instance.contentPane.m_Text.scrollPane ~= nil then
            CS.Wnd_Help.Instance.contentPane.m_Text.scrollPane:ScrollTop();
        end
    end
end