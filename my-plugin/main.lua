
local toolMenu = App.menu:GetSubMenu("tool");
local CheckTool = require(PluginPath..'/CheckDependencyNum')

toolMenu:AddItem("检测组件依赖数量", "CheckDependencyNum", function(menuItem)
    fprint("Hello world")
    CheckTool:FindAllRes()
end)

-------do cleanup here-------

function onDestroy()
    toolMenu:RemoveItem("CheckDependencyNum")
end