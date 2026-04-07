--[[
    Nexus UI Library v2.0
    Полноценная UI библиотека для Roblox
    
    Использование:
    local Nexus = loadstring(game:HttpService:GetAsync("..."))()
    local Window = Nexus:CreateWindow({ Title = "My Script" })
    local Tab = Window:CreateTab({ Name = "Main", Icon = "rbxassetid://..." })
    Tab:CreateButton({ Name = "Click Me", Callback = function() print("Hello!") end })
]]

local NexusUI = {}
NexusUI.__index = NexusUI

-- ═══════════════════════════════════════════
-- СЕРВИСЫ
-- ═══════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════
-- ТЕМЫ
-- ═══════════════════════════════════════════
local Themes = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 24),
        SecondaryBackground = Color3.fromRGB(24, 24, 32),
        TertiaryBackground = Color3.fromRGB(30, 30, 40),
        CardBackground = Color3.fromRGB(28, 28, 38),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentDark = Color3.fromRGB(71, 82, 196),
        AccentLight = Color3.fromRGB(114, 127, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 180),
        DimText = Color3.fromRGB(100, 100, 120),
        Border = Color3.fromRGB(40, 40, 55),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabInactive = Color3.fromRGB(35, 35, 48),
        TabActive = Color3.fromRGB(45, 45, 62),
        ToggleOff = Color3.fromRGB(55, 55, 70),
        SliderBackground = Color3.fromRGB(40, 40, 55),
        InputBackground = Color3.fromRGB(20, 20, 28),
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 18),
        SecondaryBackground = Color3.fromRGB(15, 15, 25),
        TertiaryBackground = Color3.fromRGB(22, 22, 35),
        CardBackground = Color3.fromRGB(18, 18, 30),
        Accent = Color3.fromRGB(138, 43, 226),
        AccentDark = Color3.fromRGB(110, 34, 180),
        AccentLight = Color3.fromRGB(165, 80, 255),
        Text = Color3.fromRGB(240, 240, 255),
        SubText = Color3.fromRGB(150, 150, 175),
        DimText = Color3.fromRGB(90, 90, 115),
        Border = Color3.fromRGB(35, 35, 50),
        Success = Color3.fromRGB(80, 200, 120),
        Error = Color3.fromRGB(255, 60, 60),
        Warning = Color3.fromRGB(255, 180, 30),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabInactive = Color3.fromRGB(25, 25, 40),
        TabActive = Color3.fromRGB(35, 35, 55),
        ToggleOff = Color3.fromRGB(45, 45, 65),
        SliderBackground = Color3.fromRGB(30, 30, 48),
        InputBackground = Color3.fromRGB(12, 12, 22),
    },
    Ocean = {
        Background = Color3.fromRGB(12, 20, 30),
        SecondaryBackground = Color3.fromRGB(16, 26, 38),
        TertiaryBackground = Color3.fromRGB(22, 34, 48),
        CardBackground = Color3.fromRGB(18, 28, 42),
        Accent = Color3.fromRGB(0, 150, 255),
        AccentDark = Color3.fromRGB(0, 120, 210),
        AccentLight = Color3.fromRGB(60, 180, 255),
        Text = Color3.fromRGB(230, 240, 255),
        SubText = Color3.fromRGB(140, 165, 190),
        DimText = Color3.fromRGB(80, 110, 140),
        Border = Color3.fromRGB(30, 45, 65),
        Success = Color3.fromRGB(0, 210, 140),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 190, 50),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabInactive = Color3.fromRGB(20, 32, 48),
        TabActive = Color3.fromRGB(28, 42, 60),
        ToggleOff = Color3.fromRGB(35, 50, 70),
        SliderBackground = Color3.fromRGB(25, 38, 55),
        InputBackground = Color3.fromRGB(10, 18, 28),
    },
    Rose = {
        Background = Color3.fromRGB(22, 14, 18),
        SecondaryBackground = Color3.fromRGB(28, 18, 24),
        TertiaryBackground = Color3.fromRGB(38, 24, 32),
        CardBackground = Color3.fromRGB(32, 20, 28),
        Accent = Color3.fromRGB(230, 60, 110),
        AccentDark = Color3.fromRGB(190, 45, 90),
        AccentLight = Color3.fromRGB(255, 100, 140),
        Text = Color3.fromRGB(255, 240, 245),
        SubText = Color3.fromRGB(180, 150, 160),
        DimText = Color3.fromRGB(120, 95, 105),
        Border = Color3.fromRGB(50, 35, 42),
        Success = Color3.fromRGB(100, 200, 130),
        Error = Color3.fromRGB(255, 70, 70),
        Warning = Color3.fromRGB(255, 175, 40),
        Shadow = Color3.fromRGB(0, 0, 0),
        TabInactive = Color3.fromRGB(35, 22, 30),
        TabActive = Color3.fromRGB(48, 30, 40),
        ToggleOff = Color3.fromRGB(55, 38, 48),
        SliderBackground = Color3.fromRGB(42, 28, 36),
        InputBackground = Color3.fromRGB(18, 12, 16),
    }
}

-- ═══════════════════════════════════════════
-- УТИЛИТЫ
-- ═══════════════════════════════════════════
local Utility = {}

function Utility:Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

function Utility:Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

function Utility:AddCorner(parent, radius)
    return Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

function Utility:AddStroke(parent, color, thickness, transparency)
    return Utility:Create("UIStroke", {
        Color = color or Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 1,
        Transparency = transparency or 0.85,
        Parent = parent
    })
end

function Utility:AddPadding(parent, top, bottom, left, right)
    return Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft = UDim.new(0, left or 8),
        PaddingRight = UDim.new(0, right or 8),
        Parent = parent
    })
end

function Utility:AddShadow(parent, theme)
    local shadow = Utility:Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = theme.Shadow,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -10),
        ZIndex = -1,
        Parent = parent
    })
    return shadow
end

function Utility:Ripple(parent, position, theme)
    local ripple = Utility:Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0, position.X - parent.AbsolutePosition.X, 0, position.Y - parent.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = parent,
        ZIndex = parent.ZIndex + 1
    })
    Utility:AddCorner(ripple, 999)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    Utility:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quint)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

function Utility:GenerateID()
    return HttpService:GenerateGUID(false)
end

-- ═══════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════
local NotificationSystem = {}

function NotificationSystem:Init(screenGui, theme)
    self.Theme = theme
    self.Container = Utility:Create("Frame", {
        Name = "NotificationContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 320, 1, 0),
        Position = UDim2.new(1, -340, 0, 0),
        Parent = screenGui,
        ZIndex = 100
    })
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = self.Container
    })
    
    Utility:AddPadding(self.Container, 0, 20, 0, 0)
    return self
end

function NotificationSystem:Notify(options)
    local theme = self.Theme
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 4
    local notifType = options.Type or "Info" -- Info, Success, Error, Warning
    
    local accentColor = theme.Accent
    if notifType == "Success" then accentColor = theme.Success
    elseif notifType == "Error" then accentColor = theme.Error
    elseif notifType == "Warning" then accentColor = theme.Warning end
    
    local icons = {
        Info = "ℹ️",
        Success = "✅",
        Error = "❌",
        Warning = "⚠️"
    }
    
    local notifFrame = Utility:Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = theme.CardBackground,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = self.Container,
        ZIndex = 100
    })
    Utility:AddCorner(notifFrame, 10)
    Utility:AddStroke(notifFrame, accentColor, 1, 0.5)
    
    -- Accent line
    Utility:Create("Frame", {
        Name = "AccentLine",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = notifFrame,
        ZIndex = 101
    })
    
    local contentFrame = Utility:Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = notifFrame,
        ZIndex = 100
    })
    Utility:AddPadding(contentFrame, 12, 12, 16, 12)
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = contentFrame
    })
    
    -- Title
    Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.GothamBold,
        Text = (icons[notifType] or "") .. "  " .. title,
        TextColor3 = theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = 1,
        Parent = contentFrame,
        ZIndex = 101
    })
    
    -- Description
    if content ~= "" then
        Utility:Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            Parent = contentFrame,
            ZIndex = 101
        })
    end
    
    -- Progress bar
    local progressContainer = Utility:Create("Frame", {
        Name = "ProgressContainer",
        BackgroundColor3 = theme.SliderBackground,
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BorderSizePixel = 0,
        LayoutOrder = 3,
        Parent = notifFrame,
        ZIndex = 101
    })
    
    local progressBar = Utility:Create("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = progressContainer,
        ZIndex = 102
    })
    
    -- Animate in
    notifFrame.BackgroundTransparency = 1
    notifFrame.Position = UDim2.new(1, 50, 0, 0)
    
    Utility:Tween(notifFrame, {BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}, 0.4)
    Utility:Tween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
    
    -- Animate out
    task.delay(duration, function()
        Utility:Tween(notifFrame, {BackgroundTransparency = 1, Position = UDim2.new(1, 50, 0, 0)}, 0.4)
        task.delay(0.5, function()
            notifFrame:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════════
-- ГЛАВНАЯ БИБЛИОТЕКА
-- ═══════════════════════════════════════════

function NexusUI:CreateWindow(options)
    local self = setmetatable({}, NexusUI)
    
    -- Параметры
    self.Title = options.Title or "Nexus UI"
    self.Subtitle = options.Subtitle or "v2.0"
    self.ThemeName = options.Theme or "Dark"
    self.Theme = Themes[self.ThemeName] or Themes.Dark
    self.Size = options.Size or UDim2.new(0, 620, 0, 440)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Toggled = true
    self.ToggleKey = options.ToggleKey or Enum.KeyCode.RightControl
    
    local theme = self.Theme
    
    -- Уничтожаем старый GUI если есть
    if CoreGui:FindFirstChild("NexusUI") then
        CoreGui:FindFirstChild("NexusUI"):Destroy()
    end
    
    -- ScreenGui
    self.ScreenGui = Utility:Create("ScreenGui", {
        Name = "NexusUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
    
    -- Попытка поставить в CoreGui
    pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    if not self.ScreenGui.Parent then
        self.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Notifications
    self.Notifications = NotificationSystem:Init(self.ScreenGui, theme)
    
    -- Основной контейнер
    local mainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = theme.Background,
        Size = self.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    self.MainFrame = mainFrame
    Utility:AddCorner(mainFrame, 12)
    Utility:AddStroke(mainFrame, theme.Border, 1, 0.3)
    Utility:AddShadow(mainFrame, theme)
    
    -- ═══ SIDEBAR ═══
    local sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = theme.SecondaryBackground,
        Size = UDim2.new(0, 180, 1, 0),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    self.Sidebar = sidebar
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = sidebar
    })
    
    -- Закрываем правые углы сайдбара
    Utility:Create("Frame", {
        Name = "CoverRight",
        BackgroundColor3 = theme.SecondaryBackground,
        Size = UDim2.new(0, 14, 1, 0),
        Position = UDim2.new(1, -14, 0, 0),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Разделитель
    Utility:Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 1, 1, -20),
        Position = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- Logo area
    local logoArea = Utility:Create("Frame", {
        Name = "LogoArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 70),
        Parent = sidebar
    })
    
    -- Logo accent bar
    Utility:Create("Frame", {
        Name = "AccentBar",
        BackgroundColor3 = theme.Accent,
        Size = UDim2.new(0.6, 0, 0, 3),
        Position = UDim2.new(0.2, 0, 1, -5),
        BorderSizePixel = 0,
        Parent = logoArea
    })
    Utility:AddCorner(logoArea:FindFirstChild("AccentBar"), 2)
    
    -- Title
    Utility:Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 15),
        Font = Enum.Font.GothamBlack,
        Text = self.Title,
        TextColor3 = theme.Text,
        TextSize = 18,
        Parent = logoArea
    })
    
    -- Subtitle
    Utility:Create("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 42),
        Font = Enum.Font.Gotham,
        Text = self.Subtitle,
        TextColor3 = theme.Accent,
        TextSize = 11,
        Parent = logoArea
    })
    
    -- Tab container
    local tabContainer = Utility:Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -120),
        Position = UDim2.new(0, 0, 0, 75),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    self.TabContainer = tabContainer
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabContainer
    })
    
    Utility:AddPadding(tabContainer, 5, 5, 10, 10)
    
    -- Bottom info
    local bottomInfo = Utility:Create("Frame", {
        Name = "BottomInfo",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -45),
        Parent = sidebar
    })
    
    Utility:Create("TextLabel", {
        Name = "UserLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 5),
        Font = Enum.Font.Gotham,
        Text = "👤 " .. Player.Name,
        TextColor3 = theme.DimText,
        TextSize = 11,
        Parent = bottomInfo
    })
    
    Utility:Create("TextLabel", {
        Name = "KeyLabel",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 22),
        Font = Enum.Font.Gotham,
        Text = "⌨️ RCtrl to toggle",
        TextColor3 = theme.DimText,
        TextSize = 10,
        Parent = bottomInfo
    })
    
    -- ═══ CONTENT AREA ═══
    local contentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -185, 1, 0),
        Position = UDim2.new(0, 185, 0, 0),
        Parent = mainFrame
    })
    self.ContentArea = contentArea
    
    -- Content header
    local contentHeader = Utility:Create("Frame", {
        Name = "ContentHeader",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        Parent = contentArea
    })
    
    self.ContentTitle = Utility:Create("TextLabel", {
        Name = "ContentTitle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Font = Enum.Font.GothamBold,
        Text = "",
        TextColor3 = theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentHeader
    })
    
    -- Close & Minimize buttons
    local controlsFrame = Utility:Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        Parent = contentHeader
    })
    
    -- Minimize button
    local minimizeBtn = Utility:Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = theme.Warning,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "–",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = controlsFrame
    })
    Utility:AddCorner(minimizeBtn, 8)
    
    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = theme.Error,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 34, 0, 0),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = controlsFrame
    })
    Utility:AddCorner(closeBtn, 8)
    
    -- Content scroll
    local contentScroll = Utility:Create("ScrollingFrame", {
        Name = "ContentScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -55),
        Position = UDim2.new(0, 0, 0, 55),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = contentArea
    })
    self.ContentScroll = contentScroll
    
    -- ═══ DRAG FUNCTIONALITY ═══
    local dragging = false
    local dragStart, startPos
    
    contentHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Utility:Tween(mainFrame, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }, 0.08)
        end
    end)
    
    -- ═══ CONTROL BUTTONS ═══
    minimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Utility:Tween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.6, function()
            self.ScreenGui:Destroy()
        end)
    end)
    
    -- Hover effects
    for _, btn in pairs({minimizeBtn, closeBtn}) do
        btn.MouseEnter:Connect(function()
            Utility:Tween(btn, {BackgroundTransparency = 0.2}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(btn, {BackgroundTransparency = 0}, 0.2)
        end)
    end
    
    -- ═══ TOGGLE KEYBIND ═══
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
    
    -- Opening animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    Utility:Tween(mainFrame, {
        Size = self.Size,
        BackgroundTransparency = 0
    }, 0.6, Enum.EasingStyle.Back)
    
    return self
end

-- ═══════════════════════════════════════════
-- TOGGLE WINDOW
-- ═══════════════════════════════════════════
function NexusUI:Toggle()
    self.Toggled = not self.Toggled
    if self.Toggled then
        self.MainFrame.Visible = true
        Utility:Tween(self.MainFrame, {
            Size = self.Size,
            BackgroundTransparency = 0
        }, 0.4, Enum.EasingStyle.Back)
    else
        Utility:Tween(self.MainFrame, {
            Size = UDim2.new(0, self.Size.X.Offset, 0, 0),
            BackgroundTransparency = 0.5
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.4, function()
            if not self.Toggled then
                self.MainFrame.Visible = false
            end
        end)
    end
end

-- ═══════════════════════════════════════════
-- NOTIFY
-- ═══════════════════════════════════════════
function NexusUI:Notify(options)
    self.Notifications:Notify(options)
end

-- ═══════════════════════════════════════════
-- CREATE TAB
-- ═══════════════════════════════════════════
function NexusUI:CreateTab(options)
    local theme = self.Theme
    local tabName = options.Name or "Tab"
    local tabIcon = options.Icon or ""
    
    local Tab = {
        Name = tabName,
        Elements = {},
        Sections = {}
    }
    
    -- Tab button
    local tabBtn = Utility:Create("TextButton", {
        Name = tabName,
        BackgroundColor3 = theme.TabInactive,
        Size = UDim2.new(1, 0, 0, 38),
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabContainer
    })
    Utility:AddCorner(tabBtn, 8)
    Tab.Button = tabBtn
    
    -- Tab accent indicator
    local tabIndicator = Utility:Create("Frame", {
        Name = "Indicator",
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BorderSizePixel = 0,
        Parent = tabBtn
    })
    Utility:AddCorner(tabIndicator, 2)
    Tab.Indicator = tabIndicator
    
    -- Icon
    if tabIcon ~= "" then
        Utility:Create("TextLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 10, 0.5, -12),
            Font = Enum.Font.Gotham,
            Text = tabIcon,
            TextColor3 = theme.SubText,
            TextSize = 16,
            Parent = tabBtn
        })
    end
    
    -- Tab name
    local tabLabel = Utility:Create("TextLabel", {
        Name = "TabName",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(tabIcon ~= "" and 44 or 20), 1, 0),
        Position = UDim2.new(0, tabIcon ~= "" and 38 or 12, 0, 0),
        Font = Enum.Font.GothamSemibold,
        Text = tabName,
        TextColor3 = theme.SubText,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabBtn
    })
    Tab.Label = tabLabel
    
    -- Content page
    local tabPage = Utility:Create("ScrollingFrame", {
        Name = tabName .. "Page",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.ContentScroll
    })
    Tab.Page = tabPage
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = tabPage
    })
    Utility:AddPadding(tabPage, 5, 15, 15, 15)
    
    -- Tab click handler
    tabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
        Utility:Ripple(tabBtn, {X = Mouse.X, Y = Mouse.Y}, theme)
    end)
    
    -- Hover
    tabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Utility:Tween(tabBtn, {BackgroundColor3 = theme.TabActive}, 0.2)
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Utility:Tween(tabBtn, {BackgroundColor3 = theme.TabInactive}, 0.2)
        end
    end)
    
    table.insert(self.Tabs, Tab)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end
    
    -- ═══════════════════════════════════════
    -- TAB ELEMENTS
    -- ═══════════════════════════════════════
    
    -- ═══ CREATE SECTION ═══
    function Tab:CreateSection(options)
        local sectionName = options.Name or "Section"
        
        local sectionFrame = Utility:Create("Frame", {
            Name = "Section_" .. sectionName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = #Tab.Elements + 1,
            Parent = tabPage
        })
        
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = sectionFrame
        })
        
        -- Section header
        local headerFrame = Utility:Create("Frame", {
            Name = "Header",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28),
            LayoutOrder = 0,
            Parent = sectionFrame
        })
        
        Utility:Create("TextLabel", {
            Name = "SectionTitle",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = sectionName:upper(),
            TextColor3 = theme.Accent,
            TextSize = 11,
            Parent = headerFrame
        })
        
        -- Divider line
        Utility:Create("Frame", {
            Name = "Line",
            BackgroundColor3 = theme.Border,
            BackgroundTransparency = 0.5,
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            BorderSizePixel = 0,
            Parent = headerFrame
        })
        
        local Section = {Frame = sectionFrame, Elements = {}}
        table.insert(Tab.Sections, Section)
        table.insert(Tab.Elements, sectionFrame)
        
        -- Section methods mirror Tab methods but parent to section
        local function createElementInSection(method, ...)
            -- We'll implement section-level element creation
        end
        
        -- Copy element creation methods to section
        function Section:CreateButton(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateButton(opts)
        end
        function Section:CreateToggle(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateToggle(opts)
        end
        function Section:CreateSlider(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateSlider(opts)
        end
        function Section:CreateDropdown(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateDropdown(opts)
        end
        function Section:CreateInput(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateInput(opts)
        end
        function Section:CreateKeybind(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateKeybind(opts)
        end
        function Section:CreateColorPicker(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateColorPicker(opts)
        end
        function Section:CreateLabel(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateLabel(opts)
        end
        function Section:CreateParagraph(opts)
            opts._parent = sectionFrame
            opts._layoutOrder = #Section.Elements + 1
            return Tab:CreateParagraph(opts)
        end
        
        return Section
    end
    
    -- ═══ CREATE LABEL ═══
    function Tab:CreateLabel(options)
        local labelText = options.Name or "Label"
        local parent = options._parent or tabPage
        
        local labelFrame = Utility:Create("Frame", {
            Name = "Label",
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 36),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(labelFrame, 8)
        
        local labelObj = Utility:Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.Gotham,
            Text = "📌 " .. labelText,
            TextColor3 = theme.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = labelFrame
        })
        
        table.insert(Tab.Elements, labelFrame)
        
        local LabelObj = {}
        function LabelObj:Set(text)
            labelObj.Text = "📌 " .. text
        end
        return LabelObj
    end
    
    -- ═══ CREATE PARAGRAPH ═══
    function Tab:CreateParagraph(options)
        local title = options.Title or "Paragraph"
        local content = options.Content or ""
        local parent = options._parent or tabPage
        
        local paraFrame = Utility:Create("Frame", {
            Name = "Paragraph",
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(paraFrame, 8)
        Utility:AddStroke(paraFrame, theme.Border, 1, 0.6)
        Utility:AddPadding(paraFrame, 12, 12, 14, 14)
        
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = paraFrame
        })
        
        local titleLabel = Utility:Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 1,
            Parent = paraFrame
        })
        
        local contentLabel = Utility:Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = 2,
            Parent = paraFrame
        })
        
        table.insert(Tab.Elements, paraFrame)
        
        local ParagraphObj = {}
        function ParagraphObj:Set(opts)
            titleLabel.Text = opts.Title or title
            contentLabel.Text = opts.Content or content
        end
        return ParagraphObj
    end
    
    -- ═══ CREATE BUTTON ═══
    function Tab:CreateButton(options)
        local buttonName = options.Name or "Button"
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local btnFrame = Utility:Create("Frame", {
            Name = "Button_" .. buttonName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 42),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            ClipsDescendants = true,
            Parent = parent
        })
        Utility:AddCorner(btnFrame, 8)
        Utility:AddStroke(btnFrame, theme.Border, 1, 0.7)
        
        local btn = Utility:Create("TextButton", {
            Name = "Button",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            Parent = btnFrame
        })
        
        Utility:Create("TextLabel", {
            Name = "ButtonText",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = buttonName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btnFrame
        })
        
        -- Arrow icon
        Utility:Create("TextLabel", {
            Name = "Arrow",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -35, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = "→",
            TextColor3 = theme.Accent,
            TextSize = 16,
            Parent = btnFrame
        })
        
        -- Interactions
        btn.MouseButton1Click:Connect(function()
            Utility:Ripple(btnFrame, {X = Mouse.X, Y = Mouse.Y}, theme)
            
            -- Press animation
            Utility:Tween(btnFrame, {BackgroundColor3 = theme.Accent}, 0.1)
            task.delay(0.15, function()
                Utility:Tween(btnFrame, {BackgroundColor3 = theme.CardBackground}, 0.3)
            end)
            
            callback()
        end)
        
        btn.MouseEnter:Connect(function()
            Utility:Tween(btnFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(btnFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
        end)
        
        table.insert(Tab.Elements, btnFrame)
        return btnFrame
    end
    
    -- ═══ CREATE TOGGLE ═══
    function Tab:CreateToggle(options)
        local toggleName = options.Name or "Toggle"
        local default = options.Default or false
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local toggled = default
        
        local toggleFrame = Utility:Create("Frame", {
            Name = "Toggle_" .. toggleName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 42),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(toggleFrame, 8)
        Utility:AddStroke(toggleFrame, theme.Border, 1, 0.7)
        
        Utility:Create("TextLabel", {
            Name = "ToggleName",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = toggleName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleFrame
        })
        
        -- Toggle switch
        local switchBg = Utility:Create("Frame", {
            Name = "SwitchBg",
            BackgroundColor3 = toggled and theme.Accent or theme.ToggleOff,
            Size = UDim2.new(0, 44, 0, 24),
            Position = UDim2.new(1, -56, 0.5, -12),
            Parent = toggleFrame
        })
        Utility:AddCorner(switchBg, 12)
        
        local switchKnob = Utility:Create("Frame", {
            Name = "Knob",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 18, 0, 18),
            Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            Parent = switchBg
        })
        Utility:AddCorner(switchKnob, 9)
        
        -- Knob shadow
        Utility:Create("UIStroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 1,
            Transparency = 0.8,
            Parent = switchKnob
        })
        
        local btn = Utility:Create("TextButton", {
            Name = "ToggleBtn",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            Parent = toggleFrame
        })
        
        local function updateToggle()
            if toggled then
                Utility:Tween(switchBg, {BackgroundColor3 = theme.Accent}, 0.3)
                Utility:Tween(switchKnob, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
                -- Glow effect
                Utility:Tween(switchKnob, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
                task.delay(0.15, function()
                    Utility:Tween(switchKnob, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
                end)
            else
                Utility:Tween(switchBg, {BackgroundColor3 = theme.ToggleOff}, 0.3)
                Utility:Tween(switchKnob, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
            end
        end
        
        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            updateToggle()
            callback(toggled)
        end)
        
        btn.MouseEnter:Connect(function()
            Utility:Tween(toggleFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            Utility:Tween(toggleFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
        end)
        
        table.insert(Tab.Elements, toggleFrame)
        
        local ToggleObj = {}
        function ToggleObj:Set(value)
            toggled = value
            updateToggle()
            callback(toggled)
        end
        function ToggleObj:Get()
            return toggled
        end
        
        -- Init
        if default then
            callback(true)
        end
        
        return ToggleObj
    end
    
    -- ═══ CREATE SLIDER ═══
    function Tab:CreateSlider(options)
        local sliderName = options.Name or "Slider"
        local min = options.Min or 0
        local max = options.Max or 100
        local default = options.Default or min
        local increment = options.Increment or 1
        local suffix = options.Suffix or ""
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local currentValue = default
        
        local sliderFrame = Utility:Create("Frame", {
            Name = "Slider_" .. sliderName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 60),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(sliderFrame, 8)
        Utility:AddStroke(sliderFrame, theme.Border, 1, 0.7)
        
        Utility:Create("TextLabel", {
            Name = "SliderName",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -80, 0, 22),
            Position = UDim2.new(0, 14, 0, 6),
            Font = Enum.Font.GothamSemibold,
            Text = sliderName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sliderFrame
        })
        
        local valueLabel = Utility:Create("TextLabel", {
            Name = "ValueLabel",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 70, 0, 22),
            Position = UDim2.new(1, -80, 0, 6),
            Font = Enum.Font.GothamBold,
            Text = tostring(currentValue) .. suffix,
            TextColor3 = theme.Accent,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = sliderFrame
        })
        
        -- Slider track
        local sliderTrack = Utility:Create("Frame", {
            Name = "Track",
            BackgroundColor3 = theme.SliderBackground,
            Size = UDim2.new(1, -28, 0, 8),
            Position = UDim2.new(0, 14, 0, 38),
            Parent = sliderFrame
        })
        Utility:AddCorner(sliderTrack, 4)
        
        local sliderFill = Utility:Create("Frame", {
            Name = "Fill",
            BackgroundColor3 = theme.Accent,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BorderSizePixel = 0,
            Parent = sliderTrack
        })
        Utility:AddCorner(sliderFill, 4)
        
        -- Gradient on fill
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.AccentDark),
                ColorSequenceKeypoint.new(1, theme.AccentLight)
            }),
            Parent = sliderFill
        })
        
        -- Knob
        local sliderKnob = Utility:Create("Frame", {
            Name = "Knob",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
            ZIndex = 5,
            Parent = sliderTrack
        })
        Utility:AddCorner(sliderKnob, 8)
        Utility:AddStroke(sliderKnob, theme.Accent, 2, 0)
        
        -- Glow
        Utility:Create("Frame", {
            Name = "Glow",
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 0.7,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, -12, 0.5, -12),
            ZIndex = 4,
            Parent = sliderKnob
        })
        Utility:AddCorner(sliderKnob:FindFirstChild("Glow"), 12)
        
        local sliding = false
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local rawValue = min + (max - min) * pos
            currentValue = math.floor(rawValue / increment + 0.5) * increment
            currentValue = math.clamp(currentValue, min, max)
            
            local fillSize = (currentValue - min) / (max - min)
            Utility:Tween(sliderFill, {Size = UDim2.new(fillSize, 0, 1, 0)}, 0.08)
            Utility:Tween(sliderKnob, {Position = UDim2.new(fillSize, -8, 0.5, -8)}, 0.08)
            valueLabel.Text = tostring(currentValue) .. suffix
            
            callback(currentValue)
        end
        
        local sliderBtn = Utility:Create("TextButton", {
            Name = "SliderButton",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            Text = "",
            ZIndex = 6,
            Parent = sliderTrack
        })
        
        sliderBtn.MouseButton1Down:Connect(function()
            sliding = true
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
        
        sliderBtn.MouseButton1Click:Connect(function()
            -- Single click update
        end)
        
        sliderFrame.MouseEnter:Connect(function()
            Utility:Tween(sliderFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        sliderFrame.MouseLeave:Connect(function()
            Utility:Tween(sliderFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
        end)
        
        table.insert(Tab.Elements, sliderFrame)
        
        local SliderObj = {}
        function SliderObj:Set(value)
            currentValue = math.clamp(value, min, max)
            local fillSize = (currentValue - min) / (max - min)
            Utility:Tween(sliderFill, {Size = UDim2.new(fillSize, 0, 1, 0)}, 0.3)
            Utility:Tween(sliderKnob, {Position = UDim2.new(fillSize, -8, 0.5, -8)}, 0.3)
            valueLabel.Text = tostring(currentValue) .. suffix
            callback(currentValue)
        end
        function SliderObj:Get()
            return currentValue
        end
        
        if default ~= min then
            callback(default)
        end
        
        return SliderObj
    end
    
    -- ═══ CREATE DROPDOWN ═══
    function Tab:CreateDropdown(options)
        local dropdownName = options.Name or "Dropdown"
        local items = options.Items or {}
        local default = options.Default or nil
        local multiSelect = options.MultiSelect or false
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local opened = false
        local selected = multiSelect and {} or default
        
        if multiSelect and default then
            if type(default) == "table" then
                selected = default
            end
        end
        
        local dropdownFrame = Utility:Create("Frame", {
            Name = "Dropdown_" .. dropdownName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 42),
            ClipsDescendants = true,
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(dropdownFrame, 8)
        Utility:AddStroke(dropdownFrame, theme.Border, 1, 0.7)
        
        -- Header
        local headerBtn = Utility:Create("TextButton", {
            Name = "Header",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 42),
            Text = "",
            Parent = dropdownFrame
        })
        
        Utility:Create("TextLabel", {
            Name = "Name",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = dropdownName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = headerBtn
        })
        
        local selectedLabel = Utility:Create("TextLabel", {
            Name = "Selected",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(1, -35, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.Gotham,
            Text = default or "Select...",
            TextColor3 = theme.SubText,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = headerBtn
        })
        
        local arrow = Utility:Create("TextLabel", {
            Name = "Arrow",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -28, 0, 0),
            Font = Enum.Font.GothamBold,
            Text = "▼",
            TextColor3 = theme.Accent,
            TextSize = 10,
            Rotation = 0,
            Parent = headerBtn
        })
        
        -- Items container
        local itemsContainer = Utility:Create("Frame", {
            Name = "Items",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 42),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = dropdownFrame
        })
        
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
            Parent = itemsContainer
        })
        Utility:AddPadding(itemsContainer, 4, 8, 8, 8)
        
        local function getDisplayText()
            if multiSelect then
                if #selected == 0 then return "None selected" end
                if #selected <= 2 then return table.concat(selected, ", ") end
                return #selected .. " selected"
            else
                return selected or "Select..."
            end
        end
        
        local function createItems()
            for _, child in pairs(itemsContainer:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            
            for i, item in ipairs(items) do
                local isSelected = false
                if multiSelect then
                    isSelected = table.find(selected, item) ~= nil
                else
                    isSelected = selected == item
                end
                
                local itemBtn = Utility:Create("TextButton", {
                    Name = "Item_" .. item,
                    BackgroundColor3 = isSelected and theme.Accent or theme.TertiaryBackground,
                    BackgroundTransparency = isSelected and 0.7 or 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    Parent = itemsContainer
                })
                Utility:AddCorner(itemBtn, 6)
                
                Utility:Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = item,
                    TextColor3 = isSelected and theme.Text or theme.SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = itemBtn
                })
                
                if isSelected then
                    Utility:Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 20, 1, 0),
                        Position = UDim2.new(1, -25, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "✓",
                        TextColor3 = theme.Accent,
                        TextSize = 14,
                        Parent = itemBtn
                    })
                end
                
                itemBtn.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local idx = table.find(selected, item)
                        if idx then
                            table.remove(selected, idx)
                        else
                            table.insert(selected, item)
                        end
                    else
                        selected = item
                    end
                    
                    selectedLabel.Text = getDisplayText()
                    createItems()
                    callback(multiSelect and selected or selected)
                    
                    if not multiSelect then
                        opened = false
                        Utility:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
                        Utility:Tween(arrow, {Rotation = 0}, 0.3)
                    end
                end)
                
                itemBtn.MouseEnter:Connect(function()
                    if not (multiSelect and table.find(selected, item) or (not multiSelect and selected == item)) then
                        Utility:Tween(itemBtn, {BackgroundColor3 = theme.TabActive}, 0.2)
                    end
                end)
                itemBtn.MouseLeave:Connect(function()
                    local isSel = multiSelect and table.find(selected, item) or (not multiSelect and selected == item)
                    if not isSel then
                        Utility:Tween(itemBtn, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
                    end
                end)
            end
        end
        
        createItems()
        selectedLabel.Text = getDisplayText()
        
        headerBtn.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                local itemCount = #items
                local targetHeight = 42 + math.min(itemCount, 6) * 34 + 16
                Utility:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3, Enum.EasingStyle.Back)
                Utility:Tween(arrow, {Rotation = 180}, 0.3)
            else
                Utility:Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
                Utility:Tween(arrow, {Rotation = 0}, 0.3)
            end
        end)
        
        headerBtn.MouseEnter:Connect(function()
            Utility:Tween(dropdownFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        headerBtn.MouseLeave:Connect(function()
            if not opened then
                Utility:Tween(dropdownFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
            end
        end)
        
        table.insert(Tab.Elements, dropdownFrame)
        
        local DropdownObj = {}
        function DropdownObj:Set(value)
            selected = value
            selectedLabel.Text = getDisplayText()
            createItems()
            callback(selected)
        end
        function DropdownObj:Refresh(newItems, keepSelected)
            items = newItems
            if not keepSelected then
                selected = multiSelect and {} or nil
                selectedLabel.Text = getDisplayText()
            end
            createItems()
        end
        function DropdownObj:Get()
            return selected
        end
        
        if default then callback(default) end
        
        return DropdownObj
    end
    
    -- ═══ CREATE INPUT ═══
    function Tab:CreateInput(options)
        local inputName = options.Name or "Input"
        local placeholder = options.Placeholder or "Type here..."
        local default = options.Default or ""
        local numeric = options.Numeric or false
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local inputFrame = Utility:Create("Frame", {
            Name = "Input_" .. inputName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 68),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(inputFrame, 8)
        Utility:AddStroke(inputFrame, theme.Border, 1, 0.7)
        
        Utility:Create("TextLabel", {
            Name = "InputName",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 22),
            Position = UDim2.new(0, 14, 0, 6),
            Font = Enum.Font.GothamSemibold,
            Text = inputName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = inputFrame
        })
        
        local inputBox = Utility:Create("TextBox", {
            Name = "InputBox",
            BackgroundColor3 = theme.InputBackground,
            Size = UDim2.new(1, -24, 0, 28),
            Position = UDim2.new(0, 12, 0, 32),
            Font = Enum.Font.Gotham,
            Text = default,
            PlaceholderText = placeholder,
            PlaceholderColor3 = theme.DimText,
            TextColor3 = theme.Text,
            TextSize = 12,
            ClearTextOnFocus = false,
            Parent = inputFrame
        })
        Utility:AddCorner(inputBox, 6)
        Utility:AddStroke(inputBox, theme.Border, 1, 0.5)
        Utility:AddPadding(inputBox, 0, 0, 10, 10)
        
        inputBox.Focused:Connect(function()
            Utility:Tween(inputBox:FindFirstChild("UIStroke"), {Color = theme.Accent, Transparency = 0}, 0.2)
        end)
        
        inputBox.FocusLost:Connect(function(enterPressed)
            Utility:Tween(inputBox:FindFirstChild("UIStroke"), {Color = theme.Border, Transparency = 0.5}, 0.2)
            if numeric then
                inputBox.Text = tostring(tonumber(inputBox.Text) or 0)
            end
            callback(inputBox.Text)
        end)
        
        inputFrame.MouseEnter:Connect(function()
            Utility:Tween(inputFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        inputFrame.MouseLeave:Connect(function()
            Utility:Tween(inputFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
        end)
        
        table.insert(Tab.Elements, inputFrame)
        
        local InputObj = {}
        function InputObj:Set(value)
            inputBox.Text = tostring(value)
            callback(inputBox.Text)
        end
        function InputObj:Get()
            return inputBox.Text
        end
        
        return InputObj
    end
    
    -- ═══ CREATE KEYBIND ═══
    function Tab:CreateKeybind(options)
        local keybindName = options.Name or "Keybind"
        local default = options.Default or Enum.KeyCode.Unknown
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local currentKey = default
        local listening = false
        
        local keybindFrame = Utility:Create("Frame", {
            Name = "Keybind_" .. keybindName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 42),
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(keybindFrame, 8)
        Utility:AddStroke(keybindFrame, theme.Border, 1, 0.7)
        
        Utility:Create("TextLabel", {
            Name = "KeybindName",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = keybindName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = keybindFrame
        })
        
        local keyButton = Utility:Create("TextButton", {
            Name = "KeyButton",
            BackgroundColor3 = theme.InputBackground,
            Size = UDim2.new(0, 75, 0, 28),
            Position = UDim2.new(1, -85, 0.5, -14),
            Font = Enum.Font.GothamBold,
            Text = default.Name or "None",
            TextColor3 = theme.Accent,
            TextSize = 11,
            Parent = keybindFrame
        })
        Utility:AddCorner(keyButton, 6)
        Utility:AddStroke(keyButton, theme.Accent, 1, 0.6)
        
        keyButton.MouseButton1Click:Connect(function()
            listening = true
            keyButton.Text = "..."
            Utility:Tween(keyButton, {BackgroundColor3 = theme.Accent}, 0.2)
            Utility:Tween(keyButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end)
        
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    keyButton.Text = input.KeyCode.Name
                    listening = false
                    Utility:Tween(keyButton, {BackgroundColor3 = theme.InputBackground}, 0.2)
                    Utility:Tween(keyButton, {TextColor3 = theme.Accent}, 0.2)
                end
            else
                if input.KeyCode == currentKey then
                    callback()
                end
            end
        end)
        
        keybindFrame.MouseEnter:Connect(function()
            Utility:Tween(keybindFrame, {BackgroundColor3 = theme.TertiaryBackground}, 0.2)
        end)
        keybindFrame.MouseLeave:Connect(function()
            Utility:Tween(keybindFrame, {BackgroundColor3 = theme.CardBackground}, 0.2)
        end)
        
        table.insert(Tab.Elements, keybindFrame)
        
        local KeybindObj = {}
        function KeybindObj:Set(key)
            currentKey = key
            keyButton.Text = key.Name
        end
        function KeybindObj:Get()
            return currentKey
        end
        return KeybindObj
    end
    
    -- ═══ CREATE COLOR PICKER ═══
    function Tab:CreateColorPicker(options)
        local pickerName = options.Name or "Color"
        local default = options.Default or Color3.fromRGB(255, 255, 255)
        local callback = options.Callback or function() end
        local parent = options._parent or tabPage
        
        local currentColor = default
        local opened = false
        local hue, sat, val = Color3.toHSV(default)
        
        local pickerFrame = Utility:Create("Frame", {
            Name = "ColorPicker_" .. pickerName,
            BackgroundColor3 = theme.CardBackground,
            Size = UDim2.new(1, 0, 0, 42),
            ClipsDescendants = true,
            LayoutOrder = options._layoutOrder or (#Tab.Elements + 1),
            Parent = parent
        })
        Utility:AddCorner(pickerFrame, 8)
        Utility:AddStroke(pickerFrame, theme.Border, 1, 0.7)
        
        -- Header
        local headerBtn = Utility:Create("TextButton", {
            Name = "Header",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 42),
            Text = "",
            Parent = pickerFrame
        })
        
        Utility:Create("TextLabel", {
            Name = "Name",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            Font = Enum.Font.GothamSemibold,
            Text = pickerName,
            TextColor3 = theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = headerBtn
        })
        
        local colorPreview = Utility:Create("Frame", {
            Name = "Preview",
            BackgroundColor3 = default,
            Size = UDim2.new(0, 30, 0, 22),
            Position = UDim2.new(1, -44, 0.5, -11),
            Parent = headerBtn
        })
        Utility:AddCorner(colorPreview, 6)
        Utility:AddStroke(colorPreview, Color3.fromRGB(255, 255, 255), 1, 0.7)
        
        -- Color picker canvas
        local pickerCanvas = Utility:Create("Frame", {
            Name = "Canvas",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -24, 0, 130),
            Position = UDim2.new(0, 12, 0, 48),
            Parent = pickerFrame
        })
        
        -- Saturation/Value box
        local satValBox = Utility:Create("Frame", {
            Name = "SatVal",
            BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
            Size = UDim2.new(1, -30, 0, 100),
            Parent = pickerCanvas
        })
        Utility:AddCorner(satValBox, 6)
        
        -- White gradient
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Parent = satValBox
        })
        
        -- Dark overlay
        local darkOverlay = Utility:Create("Frame", {
            Name = "DarkOverlay",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0,
            Parent = satValBox
        })
        Utility:AddCorner(darkOverlay, 6)
        
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Rotation = 90,
            Parent = darkOverlay
        })
        
        -- SatVal cursor
        local svCursor = Utility:Create("Frame", {
            Name = "Cursor",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(sat, -7, 1 - val, -7),
            ZIndex = 5,
            Parent = satValBox
        })
        Utility:AddCorner(svCursor, 7)
        Utility:AddStroke(svCursor, Color3.fromRGB(0, 0, 0), 2, 0.3)
        
        -- Hue slider
        local hueSlider = Utility:Create("Frame", {
            Name = "HueSlider",
            Size = UDim2.new(0, 18, 0, 100),
            Position = UDim2.new(1, -20, 0, 0),
            Parent = pickerCanvas
        })
        Utility:AddCorner(hueSlider, 5)
        
        -- Hue gradient
        Utility:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }),
            Rotation = 90,
            Parent = hueSlider
        })
        
        -- Hue cursor
        local hueCursor = Utility:Create("Frame", {
            Name = "HueCursor",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 4, 0, 6),
            Position = UDim2.new(0, -2, hue, -3),
            ZIndex = 5,
            Parent = hueSlider
        })
        Utility:AddCorner(hueCursor, 3)
        Utility:AddStroke(hueCursor, Color3.fromRGB(0, 0, 0), 1, 0.3)
        
        -- Hex display
        local hexLabel = Utility:Create("TextLabel", {
            Name = "Hex",
            BackgroundColor3 = theme.InputBackground,
            Size = UDim2.new(1, -30, 0, 22),
            Position = UDim2.new(0, 0, 0, 106),
            Font = Enum.Font.GothamBold,
            Text = "#" .. string.format("%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255),
            TextColor3 = theme.SubText,
            TextSize = 11,
            Parent = pickerCanvas
        })
        Utility:AddCorner(hexLabel, 4)
        
        local function updateColor()
            currentColor = Color3.fromHSV(hue, sat, val)
            colorPreview.BackgroundColor3 = currentColor
            satValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            svCursor.Position = UDim2.new(sat, -7, 1 - val, -7)
            hueCursor.Position = UDim2.new(0, -2, hue, -3)
            hexLabel.Text = "#" .. string.format("%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
            callback(currentColor)
        end
        
        -- SatVal interaction
        local svDragging = false
        local svButton = Utility:Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            ZIndex = 6,
            Parent = satValBox
        })
        
        svButton.MouseButton1Down:Connect(function()
            svDragging = true
        end)
        
        -- Hue interaction
        local hueDragging = false
        local hueButton = Utility:Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0, -5, 0, -5),
            Text = "",
            ZIndex = 6,
            Parent = hueSlider
        })
        
        hueButton.MouseButton1Down:Connect(function()
            hueDragging = true
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if svDragging then
                    sat = math.clamp((input.Position.X - satValBox.AbsolutePosition.X) / satValBox.AbsoluteSize.X, 0, 1)
                    val = 1 - math.clamp((input.Position.Y - satValBox.AbsolutePosition.Y) / satValBox.AbsoluteSize.Y, 0, 1)
                    updateColor()
                end
                if hueDragging then
                    hue = math.clamp((input.Position.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                    updateColor()
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                svDragging = false
                hueDragging = false
            end
        end)
        
        headerBtn.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                Utility:Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 190)}, 0.3, Enum.EasingStyle.Back)
            else
                Utility:Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
            end
        end)
        
        table.insert(Tab.Elements, pickerFrame)
        
        local ColorPickerObj = {}
        function ColorPickerObj:Set(color)
            hue, sat, val = Color3.toHSV(color)
            updateColor()
        end
        function ColorPickerObj:Get()
            return currentColor
        end
        return ColorPickerObj
    end
    
    return Tab
end

-- ═══════════════════════════════════════════
-- SELECT TAB
-- ═══════════════════════════════════════════
function NexusUI:SelectTab(tab)
    local theme = self.Theme
    
    -- Deactivate all tabs
    for _, t in pairs(self.Tabs) do
        Utility:Tween(t.Button, {BackgroundColor3 = theme.TabInactive}, 0.3)
        Utility:Tween(t.Label, {TextColor3 = theme.SubText}, 0.3)
        Utility:Tween(t.Indicator, {BackgroundTransparency = 1}, 0.3)
        t.Page.Visible = false
    end
    
    -- Activate selected tab
    self.ActiveTab = tab
    Utility:Tween(tab.Button, {BackgroundColor3 = theme.TabActive}, 0.3)
    Utility:Tween(tab.Label, {TextColor3 = theme.Text}, 0.3)
    Utility:Tween(tab.Indicator, {BackgroundTransparency = 0}, 0.3)
    tab.Page.Visible = true
    self.ContentTitle.Text = tab.Name
    
    -- Fade in animation
    for _, element in pairs(tab.Page:GetChildren()) do
        if element:IsA("Frame") then
            element.BackgroundTransparency = 1
            Utility:Tween(element, {BackgroundTransparency = 0}, 0.4)
        end
    end
end

-- ═══════════════════════════════════════════
-- SET THEME
-- ═══════════════════════════════════════════
function NexusUI:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        self.ThemeName = themeName
        -- In production, you'd recursively update all elements
    end
end

-- ═══════════════════════════════════════════
-- DESTROY
-- ═══════════════════════════════════════════
function NexusUI:Destroy()
    self.ScreenGui:Destroy()
end

return NexusUI
