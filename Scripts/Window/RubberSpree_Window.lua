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

function OnClick(context)
	print('you click',context)
	world:ShowMsgBox(context.sender.name.." Clicked","onClick");
	PracticeModeGaiBian(1111);
end

function OnChanged(context)
	print('you change',context)
	world:ShowMsgBox(context.sender.name.." change","onChanged");

end

--PracticeModeGaiBian(11111);
function PracticeModeGaiBian(param)
	local MinMind = 56;
	local MaxMind = 90;
	
	local NpcList = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom);
    for _, Npc in pairs(NpcList) do
        if Npc.CanDoAction and Npc.Rank == g_emNpcRank.Disciple then    --只筛选内门，且可行动的人。
		  local name = Npc.Name;
		  local MindState = Npc.Needs:GetNeedValue("MindState")     --获取当前心境数值。
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
			local NpcPracticeMode = Npc.PropertyMgr.Practice.PracticeMode;   --获取当前修炼模式。
			print(NpcPracticeMode);
			if NpcPracticeMode ~= CS.XiaWorld.g_emPracticeBehaviourKind.Quiet then	-- 如果不在调心模式，则切换到调心模式
			   ChangePracticeMode(Npc, "tiaoxin")
			end
		  end

		  print(name);
		  print(MindState);
        end
    end
end

function ChangePracticeMode(Npc, PracticeMode)	-- 更改NPC行为模式
	local NpcPracticeMode = Npc.PropertyMgr.Practice
		if PracticeMode == "xiulian" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Practice)	-- 修行模式
		elseif PracticeMode == "liangong" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Skill)	-- 练功模式
		elseif PracticeMode == "tiaoxin" then
			NpcPracticeMode:ChangeMode(CS.XiaWorld.g_emPracticeBehaviourKind.Quiet)	-- 调心模式
		end
end