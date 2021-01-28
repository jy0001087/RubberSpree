local Windows = GameMain:GetMod("Windows");
local RubberSpree_Window = Windows:CreateWindow("RubberSpree_Window");


function RubberSpree_Window:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("RubberSpree", "RubberSpreeWindow");
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	local bnt1 = self:GetChild("bnt_2");
	bnt1.title = "保存";
	bnt1.onClick:Add(OnClick);

	local checkbox1 = self:GetChild("n1");
	checkbox1.onChanged:Add(OnChanged);

	local checkbox2 = self:GetChild("n2");
	checkbox2.onChanged:Add(OnChanged);

	local checkbox3 = self:GetChild("n3");
	checkbox3.onChanged:Add(OnChanged);

	self.window:Center();
end

function RubberSpree_Window:OnShown()

end

function RubberSpree_Window:OnHide()

end

function RubberSpree_Window:OnClick(context)
	print('you click',context)
	world:ShowMsgBox(context.sender.name.." Clicked","onClick");
	PracticeModeGaiBian(1111);
end

function RubberSpree_Window:OnChanged(context)
	print('you change',context)
	world:ShowMsgBox(context.sender.name.." change","onChanged");

end

--PracticeModeGaiBian(11111);
function RubberSpree_Window:PracticeModeGaiBian(param)
	local MinMind = 50;
	local MaxMind = 90;
	
	local NpcList = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom);
    for _, Npc in pairs(NpcList) do
        if Npc.CanDoAction and Npc.Rank == g_emNpcRank.Disciple then    --只筛选内门，且可行动的人。
		  local name = Npc.Name;
		  local MindState = Npc.Needs:GetNeedValue("MindState")     --获取当前心境数值。
		  local NpcPracticeMode = Npc.PropertyMgr.Practice.PracticeMode;   --获取当前修炼模式。
		  print(NpcPracticeMode);
		  if MindState <= MinMind then
			print('MindState is too low');
			local Job = Npc.JobEngine.CurJob; -- 取NPC当前工作
			local JobType = nil;
			if Job ~= nil and Job.jobdef ~= nil then
				JobType = Job.jobdef.Name
			end
			print(JobType);
			if JobType == "JobPractice" or JobType == 'JobPracticeSkill' then	-- 如果还在修行/练习状态，则打断当前任务
				Job:InterruptJob()
			end
			if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then	-- 如果不在调心模式，则切换到调心模式
			   self:ChangePracticeMode(Npc, "tiaoxin");
			end
		  elseif MindState >= MaxMind then	-- 心境高于设定
			print('Enter HighMind satuation')
			if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Practice or NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Skill then	-- 如果不在修行/练习模式，则切换到修行模式
				self:ChangePracticeMode(Npc, "xiulian");
			end
		  else	-- 如果心境值处于区间段，但既不在修行/练习，也不在调心，则切换到调心模式。
			print('Enter between satuation')
			if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Practice and NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet and NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Skill then
				self:ChangePracticeMode(Npc, "tiaoxin");
			end
		  end

		  print(name);
		  print(MindState);
        end
    end
end

function RubberSpree_Window:ChangePracticeMode(Npc, PracticeMode)	-- 更改NPC行为模式
	local NpcPracticeMode = Npc.PropertyMgr.Practice
		if PracticeMode == "xiulian" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Practice)	-- 修行模式
		elseif PracticeMode == "liangong" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Skill)	-- 练功模式
		elseif PracticeMode == "tiaoxin" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Quiet)	-- 调心模式
		end
end

function RubberSpree_Window:MedicineIntakeRegulation(parm)     --内门药物控制
	local NpcList = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom);
	print("MedicineIntakeRegulation is active  now  ");
    for _, Npc in pairs(NpcList) do
        if Npc.CanDoAction and Npc.Rank == g_emNpcRank.Disciple then    --只筛选内门，且可行动的人。
			if Npc.CanDoAction then
						self:MedicineTake(Npc, "qingxin");
						self:MedicineTake(Npc, "jingyuan");
						self:MedicineTake(Npc, "huangya");
						self:medicineTake(Npc, "jingyuanzhibu");
			end
		end
	end
end

function RubberSpree_Window:MedicineTake(Npc, Buff)	-- 添加NPC吃药行为
	local BuffName
	local ItemName
	if Buff == "qingxin" then
		 BuffName = "Dan_CalmDown"
		 ItemName = "Item_Dan_CalmDown"
	elseif Buff == "jingyuan" then
		 BuffName = "Dan_JingYuan3"
		 ItemName = "Item_Dan_JingYuan3"
	elseif Buff == "huangya" then
		 BuffName = "Dan_PracticeSpeed"
		 ItemName = "Item_Dan_PracticeSpeed"
	elseif Buff == "jingyuanzhibu" then
		 local PracticeNutrition =  Npc.Needs:GetNeedValue("Practice");     --获取当前精元数值(参数值参见 g_emNeedType --API)。
		 print(PracticeNutrition);
		 if PracticeNutrition < 50 then    --精元值小于50 吃精元大补丹
			BuffName = "￥";
			ItemName = "￥";                                
	     end
		 --PracticeNutrition addition process logic;
	else
		return
	end
	if Npc.PropertyMgr:FindModifier(BuffName) == nil then
		local Item = Map.Things:FindItem(null, 9999, ItemName, 0, false, null, 0, 9999, null, false)
		if Item ~= nil then
			Npc:AddCommandIfNotExist("EatItem",Item)
		end
	end
end

function RubberSpree_Window:FoodMaintain(parm)
	local FoodName = "￥";
	local Item = Map.Things:FindItem(null, 9999, FoodName, 0, false, null, 0, 9999, null, false);
	if Item < 20 then
		--向灶台下达做饭指令。
	end
end