-- Enlever l'héritage => Possède 2 fenêtre superposée (ZOrder)
-- 1 transparente et 1 pour le couleur

local LayoutMode = {
    Left = {},
    Right = {},
    Mid = {},
    Mid2 = {} --Mid mais aussi en haut
}

local TextPosition = {
    Top = {},
    Bottom = {},
}

Bar = class(Turbine.UI.Window)

function Bar:Constructor()
    Turbine.UI.Window.Constructor(self)
    self.quickslots = {}
    self.textPosition = TextPosition.Bottom
    self.quickslotsWidth = 1
    self.quickslotsHeight = 1
    self.quickslotsLayout = LayoutMode.Left
    self.quickslotsInterstice = 0
    self.quickslotsBorder = 1

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetText("Text")
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomCenter)
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro13)
    self.label:SetHeight(13)
    self.label:SetLeft(0)
    self.label:SetOpacity(1)
    self.label:SetZOrder(2)
    self.label:SetVisible(false)

    self.fond = Turbine.UI.Window()
    self.fond:SetParent(self)
    self.fond:SetOpacity(0.5)
    self.fond:SetZOrder(1)
    self.fond:SetVisible(true)

    self:Update()
end

--Do not mark as update ! Only some calculations when quickslots, text or width are modified
function Bar:Update()
    if self.quickslots[1] == nil  then
        self.quickslotsWidth = 1
        self.quickslotsHeight = 1
    else
        self.quickslotsWidth = math.min(self.quickslotsWidth, #self.quickslots)
        self.quickslotsHeight = math.ceil(#self.quickslots / self.quickslotsWidth)

        for i, x in ipairs(self.quickslots) do
            i = i - 1
            x:SetPosition(-2 + self.quickslotsBorder + (i % self.quickslotsWidth) * self:GetQuickslotsSize() + (i % self.quickslotsWidth) * self.quickslotsInterstice, self.quickslotsBorder - 2 + math.floor(i / self.quickslotsWidth) * self:GetQuickslotsSize() + (math.floor(i / self.quickslotsWidth)) * self.quickslotsInterstice)
        end
    end

    if self.label:IsVisible() then
        self:SetSize(2 * self.quickslotsBorder + self.quickslotsWidth * self:GetQuickslotsSize() + (self.quickslotsWidth - 1) * self.quickslotsInterstice, 2 * self.quickslotsBorder + self.quickslotsHeight * self:GetQuickslotsSize() + (self.quickslotsHeight - 1) * self.quickslotsInterstice + self.label:GetHeight())
        self.fond:SetSize(2 * self.quickslotsBorder + self.quickslotsWidth * self:GetQuickslotsSize() + (self.quickslotsWidth - 1) * self.quickslotsInterstice, 2 * self.quickslotsBorder + self.quickslotsHeight * self:GetQuickslotsSize() + (self.quickslotsHeight - 1) * self.quickslotsInterstice + self.label:GetHeight())
        self.label:SetWidth(self:GetWidth())
        self.label:SetTop(self:GetHeight() - self.label:GetHeight())
        self.label:SetVisible(true)
    else
        self:SetSize(2 * self.quickslotsBorder + self.quickslotsWidth * self:GetQuickslotsSize() + (self.quickslotsWidth - 1) * self.quickslotsInterstice, 2 * self.quickslotsBorder + self.quickslotsHeight * self:GetQuickslotsSize() + (self.quickslotsHeight - 1) * self.quickslotsInterstice)
        self.fond:SetSize(2 * self.quickslotsBorder + self.quickslotsWidth * self:GetQuickslotsSize() + (self.quickslotsWidth - 1) * self.quickslotsInterstice, 2 * self.quickslotsBorder + self.quickslotsHeight * self:GetQuickslotsSize() + (self.quickslotsHeight - 1) * self.quickslotsInterstice)
        self.label:SetVisible(false)
    end

    
end

function Bar:SetTextSize(value)
    self.label:SetTextSize(value)

    self:Update()
end

function Bar:GetTextSize()
    return self.label:GetHeight()
end

function Bar:SetQuickslots(value)
    self.quickslots = value
    for _, x in pairs(self.quickslots) do
        x:SetParent(self)
        x:SetZOrder(2)
        x:SetVisible(true)
        Turbine.Shell.WriteLine(self:GetQuickslotsSize()) --/!\ ICI DEBUG
    end

    self:Update()
end

function Bar:GetQuickslots()
    return self.quickslots
end

function Bar:SetTextVisible(value)
    self.label:SetVisible(value)

    self:Update()
end

function Bar:IsTextVisible()
    return self.label:IsVisible()
end

function Bar:SetQuickslotsWidth(value)
    self.quickslotsWidth = value

    self:Update()
end

function Bar:GetQuickslotsWidth()
    return self.quickslotsWidth
end

function Bar:SetQuickslotsLayout(value)
    self.quickslotsLayout = value

    self:Update()
end

function Bar:GetQuickslotsLayout()
    return self.quickslotsLayout
end

function Bar:SetQuickslotsSize(value)
    for _, x in pairs(self.quickslots) do
        x:SetSize(value, value)
    end

    self:Update()
end

function Bar:GetQuickslotsSize()
    if self.quickslots[1] == nil then
        return 32
    else
        return self.quickslots[1]:GetHeight()
    end
end

function Bar:SetQuickslotsBorder(value)
    self.quickslotsBorder = value

    self:Update()
end

function Bar:GetQuickslotsBorder()
    return self.quickslotsBorder
end

function Bar:SetColor(value)
    self.fond:SetBackColor(value)
end

function Bar:SetOpacity(value)
    self.fond:SetOpacity(value)
end