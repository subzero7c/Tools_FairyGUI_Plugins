local CheckDependencyNum = {}
local App = App
local CSXML = CS.FairyGUI.Utils.XML

-- {
-- ResType ,  PkgName:Count,

-- }

local resMap = {}
local componentPaths = {}
function CheckDependencyNum:FormatTable(t, tabcount)
    tabcount = tabcount or 0
    if tabcount > 5 then
        --防止栈溢出
        return "<table too deep>" .. tostring(t)
    end
    local str = ""
    if type(t) == "table" then
        for k, v in pairs(t) do
            local tab = string.rep("\t", tabcount)
            if type(v) == "table" then
                str = str .. tab .. string.format("[%s] = {",self: FormatValue(k)) .. "\n"
                str = str .. self:FormatTable(v, tabcount + 1) .. tab .. "}\n"
            else
                str = str .. tab .. string.format("[%s] = %s", self:FormatValue(k), self:FormatValue(v)) .. ",\n"
            end
        end
    else
        str = str .. tostring(t) .. "\n"
    end
    return str
end

local function traveXml(xml, selector, callbak)
    if selector(xml) then
        callbak(xml)
    end
    local elements = xml.elements
    if not elements then
        return
    end
    local rawList = elements.rawList
    local count = rawList.Count
    for i = 0, count - 1 do
        traveXml(rawList[i], selector, callbak)
    end
end

local function readxml(path)
    local f = io.open(path, "r")
    if f then
        local xml = f:read("*a")
        f:close()
        return xml
    end
end

---comment 查询资源
function CheckDependencyNum:FindAllRes()
    local project = App.project
    if not project.opened then
        return
    end

    local allPackages = project.allPackages
    local numPkg = allPackages.Count
    local pkg, items, numItem
    for i = 0, numPkg - 1 do
        pkg = allPackages[i]
        items = pkg.items
        numItem = items.Count
        for j = 0, numItem - 1 do
            local item = items[j]
            self:AddDependInfo(item, pkg)
        end
    end

    for k, v in pairs(componentPaths) do 
        fprint(k)
        fprint(v)
    end
--    fprint( self:FormatTable(componentPaths))
--    fprint(self:FormatTable(resMap))
end

function CheckDependencyNum:AddDependInfo(item, pkg)
    if item.type == "component" then
        local path = string.format("%s/%s/%s", pkg.basePath, item.path, item.fileName)
        path = path:gsub("\\", "/"):gsub("///", "/"):gsub("////", "/"):gsub("//", "/")
        -- fprint(item.id)
        -- fprint(path)
        componentPaths[tostring( item.id) ] = path
        local xmlReader = readxml(path)

    elseif item.type == "image" then
        -- fprint(item.)
        resMap[item.id] = item.name
    else
    end
end


-- if xmlReader then
--     local xml = CSXML(xmlReader)
--     traveXml(
--         xml,
--         function(node)
--             -- if node.pkg and node.pkg~=pkg then
--             return true
--             -- end
--         end,
--         function(node)
--             if node.pkg ~= pkg then
--                 fprint(node.name .. "    " )
--             end
--         end
--     )
-- end

return CheckDependencyNum
