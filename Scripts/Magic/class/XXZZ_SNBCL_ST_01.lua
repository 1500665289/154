--移花接木
local tbTable = GameMain:GetMod("MagicHelper");--获取神通模块 这里不要动
local tbMagic = tbTable:GetMagic("XXZZ_SNBCL_ST_01");--创建一个新的神通class
--注意-
--神通脚本运行的时候有两个固定变量
--self.bind 执行神通的npcObj
--self.magic 当前神通的数据，也就是定义在xml里的数据

local _COSTLING = 0;  -- 修正拼写错误
local _R = 3;
local tbMine = 
{
	{20,"Healroot"},
	{15,"Ginseng"},
	{15,"Mint"},
	{15,"MagicHerb"},
	{15,"Raspberry"},
	{10,"TreeGinkgo"},
	{10,"TreePear"},
	{10,"TreePine"},
	{10,"TreePoplar"},
	{5,"TreePine_Big"},
	{5,"TreeGinkgo_Big"},
};


function tbMagic:Init()
end

--目标合法检测 首先会通过magic的SelectTarget过滤，然后再通过这里过滤
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体
function tbMagic:TargetCheck(key, t)
	return true;
end

--神通是否可用
function tbMagic:EnableCheck(npc)
	return true;
end

--开始施展神通
function tbMagic:MagicEnter(IDs, IsThing)
	self.curIndex = 0;
	self.jump = 0;
	if self.bind then
		self.bind:EnterFlying();
	end
	self.begin = IDs and IDs[0] or 0;  -- 增加空值检查
end

--神通施展过程中，需要返回值
--成功率跟人物心境有关，200心境则满成功率。
--返回值  0继续 1成功并结束 -1失败并结束
function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束 duration:已持续时间
	if not self.grids then
		self.grids = GridMgr:GetAroundGrid(self.begin, _R, false);
	end
	
	if self.grids and self.grids.Count then
		self:SetProgress(self.curIndex/self.grids.Count);--UI上显示的进度
	end
	
	self.jump = self.jump + dt;	
	if self.jump >= 0.1 then
		local key = self.grids and self.grids[self.curIndex];
		if key and world:CheckRate( 1 - (self.curIndex / self.grids.Count) - 0.1) and self:CreateMine(key) then
			if self.bind then
				self.bind:AddLing(-_COSTLING);
			end
			self.jump = 0;
		end		
		self.curIndex = self.curIndex + 1;	
		if not self.grids or self.curIndex >= self.grids.Count or (self.bind and self.bind.LingV < _COSTLING) then
			return 1;
		end		
	end
	return 0;
end

function tbMagic:CreateMine(key)
	if not key or Map:CheckGridWalkAble(key, false) == false then
		return false;
	end
	local g_emPlantKind = CS.XiaWorld.g_emPlantKind;
	local Things = Map.Things;
	local oldbuilding = Things:GetThingAtGrid(key, 4);
	if oldbuilding == nil then
		local oldplant = Things:GetThingAtGrid(key, 3);
		if oldplant ~= nil then
			if oldplant.def and oldplant.def.Plant and oldplant.def.Plant.Kind ~= g_emPlantKind.Mine then
				ThingMgr:RemoveThing(oldplant, false, false);
			else
				return false;
			end
		end
		local olditem = Things:GetThingAtGrid(key, 2);
		local index = Lib:CountRateTable(tbMine, 1);
		ThingMgr:AddPlantThing(key, tbMine[index][2],nil); 
		world:PlayEffect(34, key, 5);
		if olditem ~= nil then
			olditem:PickUp();
			Map:DropItem(olditem, key);
		end
		return true;
	end		
	return false;
end

function tbMagic:MagicLeave(success)
	self.grids = nil;
	if self.bind then
		self.bind:LeaveFlying();
	end
end

function tbMagic:OnGetSaveData()
	return {
		Index = self.curIndex or 0,
		Jump = self.jump or 0
	};
end

function tbMagic:OnLoadData(tbData, IDs, IsThing)	
	self.begin = IDs and IDs[0] or 0;  -- 增加空值检查
	self.curIndex = tbData.Index or 0;
	self.jump = tbData.Jump or 0;	
end