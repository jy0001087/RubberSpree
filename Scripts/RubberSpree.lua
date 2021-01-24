local RubberSpree = GameMain:NewMod("RubberSpree");--先注册一个新的MOD模块

function RubberSpree:OnInit()
	print("RubberSpree Initlized");
end

function RubberSpree:OnSetHotKey()
	print("Example OnSetHotKey");
	
	--ID为快捷键注册时的编码，编码需要是唯一的，不可为空
	--Name为快捷键的名称，会显示到快捷键面板上，需要将本文件转换为UTF-8才可使用中文
	--Type为快捷键所属类别，快捷键会根据类别自动分类，不可为空
	--InitialKey1为快捷键的第一组按键，使用"+"进行连接组合键位，键位请阅读快捷键列表找到所需要的键盘编码，可以为空
	--InitialKey2为快捷键的第二组按键，使用"+"进行连接组合键位，键位请阅读快捷键列表找到所需要的键盘编码，可以为空
	--快捷键有区分大小写，请按快捷键列表的键盘编码输入
	local tbHotKey = { {ID = "RubberSpree" , Name = "RubberSpree" , Type = "Mod", InitialKey1 = "LeftShift+R" , InitialKey2 = "Equals" } };
	
	return tbHotKey;
end

function RubberSpree:OnHotKey(ID,state)
     
	--ID为快捷键注册时的编码，系统识别快捷键的唯一标识
	--state为快捷键当前操作状态，按下"down"，持续"stay"，离开"up"
	if ID == "RubberSpree" and state == "down" then 
	   print("=========== Test is down ============="); --在ID和state都对应的情况下，会执行此部分逻辑
	   GameMain:GetMod("Windows"):GetWindow("RubberSpree_Window"):Show();
    end	   
	
end
