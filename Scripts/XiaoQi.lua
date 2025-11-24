local XiaoQi = GameMain:GetMod("XiaoQi");


function XiaoQi:OnAfterLoad()
	local file = "Settings/Ui/Help/Help.xml"
	local ModPaths = XiaoQi:GetPaths("Settings/Ui/Help/Help.xml");
	for k,v in pairs(ModPaths) do
		local PathData = v;
		local text = CS.GFileUtil.ReadTXT(PathData, true);
		if text.Length == 0 then
			break;
		end
		local xmlSerializer = CS.System.Xml.Serialization.XmlSerializer(typeof(CS.XiaWorld.UIHelpDefs));
		local uihelpDefs = xmlSerializer:Deserialize(CS.System.IO.StringReader(text));
		XiaoQi:LoadHelp(uihelpDefs)
	end
end

function XiaoQi:LoadHelp(defs)
	xlua.private_accessible(CS.XiaWorld.UILogicMgr);
	for k,v in pairs(defs.Datas) do
		local uihelpDef = v;
		if CS.XiaWorld.UILogicMgr.Instance.mapHelpData:ContainsKey(v.Name) then
			CS.XiaWorld.UILogicMgr.Instance.mapHelpData:Remove(v.Name);
		end
		CS.XiaWorld.UILogicMgr.Instance.mapHelpData:Add(v.Name,v);
	end
end

function XiaoQi:GetPaths(filepath)
	local list = {}
	local Mods = CS.ModsMgr.Instance.Mods
	for k,v in pairs(Mods) do
		if v.IsActive then
			local path2 = v.Path .. "/" .. filepath;
			if CS.System.IO.File.Exists(path2) then
				table.insert(list,path2)
			end
		end
	end
	return list;
end

function XiaoQi:OnEnter()
	CS.Wnd_Help.Instance:Show();
	CS.Wnd_Help.Instance:Hide();
	CS.Wnd_Help.Instance.contentPane.m_Text.m_title.onClickLink:Add(XiaoQi.onClickLink); 
end

function XiaoQi.onClickLink(Context)
	local link = Context.data;
	if string.find(link,"http://") or string.find(link,"https://") then
		CS.UnityEngine.Application.OpenURL(Context.data)
	end
	if string.find(link,"tencent://") and CS.System.Diagnostics.Process.GetProcessesByName("QQ").Length then
		CS.UnityEngine.Application.OpenURL(Context.data)
	end
end

function XiaoQi:ShowHelp(Context)
	CS.Wnd_Help.Instance:Show();
	local list = CS.Wnd_Help.Instance.contentPane.m_menu;
	for i=0, list.numChildren -1 do
		local item = list:GetChildAt(i);
		if item.m_n19.data == "XiaoQi_Main" then
			item.m_n19.onClick:Call();
		end
	end
	local helpDef = UILogicMgr:GetHelpDef("XiaoQi_1");
	CS.Wnd_Help.Instance.contentPane.m_Text.text = helpDef.Text;
	CS.Wnd_Help.Instance.contentPane.m_Text.scrollPane:ScrollTop();
end