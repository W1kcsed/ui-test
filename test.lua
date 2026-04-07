--[[
    ═══════════════════════════════════════════
    🎨 NEXUS UI - MINIMAL EDITION
    Чистый, минималистичный дизайн без мультяшности
    ═══════════════════════════════════════════
]]

local NexusUI = {}
NexusUI.__index = NexusUI

-- Сервисы
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ═══════════════════════════════════════════
-- МИНИМАЛИСТИЧНАЯ ТЕМА
-- ═══════════════════════════════════════════
local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Surface = Color3.fromRGB(28, 28, 28),
    Element = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(100, 200, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(50, 50, 50),
    Success = Color3.fromRGB(80, 200, 120),
    Error = Color3.fromRGB(240, 80, 80),
}

-- ═══════════════════════════════════════════
-- УТИЛИТЫ
-- ═══════════════════════════════════════════
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
end

-- ═══════════════════════════════════════════
-- СОЗДАНИЕ ОКНА
-- ═══════════════════════════════════════════
function NexusUI:CreateWindow(config)
    local self = setmetatable({}, NexusUI)
    
    self.Title = config.Title or "Nexus UI"
    self.Size = config.Size or UDim2.new(0, 550, 0, 400)
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Удаляем старый UI
    if CoreGui:FindFirstChild("NexusUI") then
        CoreGui:FindFirstChild("NexusUI"):Destroy()
    end
    
    -- ScreenGui
    self.ScreenGui = Create("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    if not self.ScreenGui.Parent then
        self.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    self.Main = Create("Frame", {
        Name = "Main",
        Size = self.Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = self.Main})
    
    -- Тень
    Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        ZIndex = 0,
        Parent = self.Main
    })
    
    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TopBar})
    
    -- Закрываем низ топбара
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = TopBar
    })
    
    -- Title
    Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = self.Title,
        TextColor3 = Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Theme.Element,
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Theme.Text,
        Parent = TopBar
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = CloseBtn})
    
    CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Tab Container (Left)
    self.TabContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(0, 140, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = self.TabContainer
    })
    
    -- Content Container (Right)
    self.ContentContainer = Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -160, 1, -50),
        Position = UDim2.new(0, 155, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main
    })
    
    -- Drag
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return self
end

-- ═══════════════════════════════════════════
-- CREATE TAB
-- ═══════════════════════════════════════════
function NexusUI:CreateTab(config)
    local Tab = {
        Name = config.Name or "Tab",
        Elements = {}
    }
    
    -- Tab Button
    local TabBtn = Create("TextButton", {
        Name = Tab.Name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Theme.Element,
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabContainer
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TabBtn})
    
    Create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = Tab.Name,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TabBtn
    })
    
    -- Tab Page
    Tab.Page = Create("Frame", {
        Name = Tab.Name .. "_Page",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentContainer
    })
    
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = Tab.Page
    })
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Theme.Element
            tab.Button.TextLabel.TextColor3 = Theme.SubText
        end
        
        Tab.Page.Visible = true
        TabBtn.BackgroundColor3 = Theme.Accent
        TabBtn.TextLabel.TextColor3 = Theme.Text
        self.ActiveTab = Tab
    end)
    
    Tab.Button = TabBtn
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        TabBtn.MouseButton1Click()
    end
    
    -- ═══════════════════════════════════════════
    -- TAB ELEMENTS
    -- ═══════════════════════════════════════════
    
    function Tab:AddSection(name)
        local Section = Create("TextLabel", {
            Name = "Section",
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = name:upper(),
            TextColor3 = Theme.Accent,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab.Page
        })
        
        Create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0,
            Parent = Section
        })
        
        return Section
    end
    
    function Tab:AddLabel(text)
        local Label = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Surface,
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Label})
        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = Label
        })
        
        return {
            Set = function(_, txt)
                Label.Text = txt
            end
        }
    end
    
    function Tab:AddButton(name, callback)
        local Btn = Create("TextButton", {
            Name = "Button",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Surface,
            Text = "",
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Btn})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Btn
        })
        
        Btn.MouseEnter:Connect(function()
            Tween(Btn, {BackgroundColor3 = Theme.Element})
        end)
        
        Btn.MouseLeave:Connect(function()
            Tween(Btn, {BackgroundColor3 = Theme.Surface})
        end)
        
        Btn.MouseButton1Click:Connect(function()
            Tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.1)
            task.wait(0.1)
            Tween(Btn, {BackgroundColor3 = Theme.Surface}, 0.2)
            callback()
        end)
        
        return Btn
    end
    
    function Tab:AddToggle(name, default, callback)
        local toggled = default or false
        
        local Toggle = Create("Frame", {
            Name = "Toggle",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Surface,
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Toggle})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Toggle
        })
        
        local Switch = Create("Frame", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = toggled and Theme.Accent or Theme.Element,
            Parent = Toggle
        })
        
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Switch})
        
        local Knob = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Switch
        })
        
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
        
        local Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = Toggle
        })
        
        Btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            Tween(Switch, {BackgroundColor3 = toggled and Theme.Accent or Theme.Element})
            Tween(Knob, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
            callback(toggled)
        end)
        
        return {
            Set = function(_, val)
                toggled = val
                Tween(Switch, {BackgroundColor3 = toggled and Theme.Accent or Theme.Element})
                Tween(Knob, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                callback(toggled)
            end
        }
    end
    
    function Tab:AddSlider(name, min, max, default, callback)
        local value = default or min
        
        local Slider = Create("Frame", {
            Name = "Slider",
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.Surface,
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Slider})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Slider
        })
        
        local ValueLabel = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -60, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = tostring(value),
            TextColor3 = Theme.Accent,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = Slider
        })
        
        local SliderBar = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 4),
            Position = UDim2.new(0, 10, 1, -12),
            BackgroundColor3 = Theme.Element,
            Parent = Slider
        })
        
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBar})
        
        local Fill = Create("Frame", {
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = SliderBar
        })
        
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})
        
        local dragging = false
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                ValueLabel.Text = tostring(value)
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                callback(value)
            end
        end)
        
        return {
            Set = function(_, val)
                value = math.clamp(val, min, max)
                ValueLabel.Text = tostring(value)
                local pos = (value - min) / (max - min)
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)})
                callback(value)
            end
        }
    end
    
    function Tab:AddDropdown(name, items, default, callback)
        local selected = default or items[1]
        local opened = false
        
        local Dropdown = Create("Frame", {
            Name = "Dropdown",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Surface,
            ClipsDescendants = true,
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Dropdown})
        
        local Header = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = "",
            Parent = Dropdown
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Header
        })
        
        local SelectedLabel = Create("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(1, -110, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = selected,
            TextColor3 = Theme.Accent,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = Header
        })
        
        local ItemsContainer = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 35),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = Dropdown
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
            Parent = ItemsContainer
        })
        
        for _, item in ipairs(items) do
            local ItemBtn = Create("TextButton", {
                Size = UDim2.new(1, -10, 0, 28),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundColor3 = Theme.Element,
                Text = "",
                Parent = ItemsContainer
            })
            
            Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = ItemBtn})
            
            Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                Text = item,
                TextColor3 = Theme.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ItemBtn
            })
            
            ItemBtn.MouseButton1Click:Connect(function()
                selected = item
                SelectedLabel.Text = item
                opened = false
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35)})
                callback(item)
            end)
        end
        
        Header.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35 + ItemsContainer.AbsoluteSize.Y + 5)})
            else
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 35)})
            end
        end)
        
        return {
            Set = function(_, val)
                selected = val
                SelectedLabel.Text = val
                callback(val)
            end
        }
    end
    
    function Tab:AddInput(name, placeholder, callback)
        local Input = Create("Frame", {
            Name = "Input",
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = Theme.Surface,
            Parent = Tab.Page
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Input})
        
        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Input
        })
        
        local Box = Create("TextBox", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 1, -30),
            BackgroundColor3 = Theme.Element,
            Font = Enum.Font.Gotham,
            PlaceholderText = placeholder,
            PlaceholderColor3 = Theme.SubText,
            Text = "",
            TextColor3 = Theme.Text,
            TextSize = 11,
            ClearTextOnFocus = false,
            Parent = Input
        })
        
        Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Box})
        Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = Box})
        
        Box.FocusLost:Connect(function()
            callback(Box.Text)
        end)
        
        return {
            Set = function(_, txt)
                Box.Text = txt
                callback(txt)
            end
        }
    end
    
    return Tab
end

return NexusUI
