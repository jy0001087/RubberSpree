local Windows = GameMain:GetMod("Windows");
local RubberSpree_Window = Windows:CreateWindow("RubberSpree_Window");

function RubberSpree_Window:OnInit()
	self.window.contentPane =  UIPackage.CreateObject("RubberSpree", "RubberSpreeWindow");
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	local bnt1 = self:GetChild("bnt_2");
	bnt1.title = "保存";
end

function RubberSpree_Window:OnShown()

end

function RubberSpree_Window:OnHide()

end