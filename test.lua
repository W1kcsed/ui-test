local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(25, 25, 25),
    SurfaceLight = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentDark = Color3.fromRGB(110, 34, 180),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(45, 45, 45),
    Success = Color3.fromRGB(87, 242, 135),
    Error = Color3.fromRGB(255, 85, 85),
}

local function Tween(obj, props, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function Create(class, properties)
    local obj = Instance.new(class)
    for prop, val in pairs(properties) do
        if prop ~= "Children" then
            obj[prop] = val
        end
    end
    if properties.Children then
        for _, child in ipairs(properties.Children) do
            child.Parent = obj
        end
    end
    return obj
end

local function Ripple(obj, x, y)
    local circle = Create("Frame", {
        Parent = obj,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, x - obj.AbsolutePosition.X, 0, y - obj.AbsolutePosition.Y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 100
    })
    
    Create("UICorner", {
        Parent = circle,
        CornerRadius = UDim.new(1, 0)
    })
    
    local size = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 2
    
    Tween(circle, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quart)
    
    task.delay(0.6, function()
        circle:Destroy()
    end)
end

function Library:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    if CoreGui:FindFirstChild("UILibrary") then
        CoreGui:FindFirstChild("UILibrary"):Destroy()
    end
    
    Window.ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    pcall(function()
        Window.ScreenGui.Parent = CoreGui
    end)
    
    if not Window.ScreenGui.Parent then
        Window.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    Window.Main = Create("Frame", {
        Parent = Window.ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -220),
        Size = UDim2.new(0, 0, 0, 0),
        ClipsDescendants = true,
        Children = {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            })
        }
    })
    
    Create("ImageLabel", {
        Parent = Window.Main,
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = -1
    })
    
    local TopBar = Create("Frame", {
        Parent = Window.Main,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45),
        Children = {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            })
        }
    })
    
    Create("Frame", {
        Parent = TopBar,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10)
    })
    
    Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "UI Library",
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local CloseButton = Create("TextButton", {
        Parent = TopBar,
        BackgroundColor3 = Theme.Error,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -35, 0.5, -12.5),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        AutoButtonColor = false,
        Children = {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        }
    })
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.2)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Ripple(CloseButton, Mouse.X, Mouse.Y)
        Tween(Window.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        Window.ScreenGui:Destroy()
    end)
    
    local TabContainer = Create("Frame", {
        Parent = Window.Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 140, 1, -45),
        ClipsDescendants = true
    })
    
    local TabList = Create("ScrollingFrame", {
        Parent = TabContainer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -10, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    Create("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    })
    
    local ContentContainer = Create("Frame", {
        Parent = Window.Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 55),
        Size = UDim2.new(1, -160, 1, -65),
        ClipsDescendants = true
    })
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Window.Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Tween(Window.Main, {Size = UDim2.new(0, 600, 0, 440)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        
        Tab.Button = Create("TextButton", {
            Parent = TabList,
            BackgroundColor3 = Theme.SurfaceLight,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 36),
            AutoButtonColor = false,
            Text = "",
            ClipsDescendants = true,
            Children = {
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6)
                })
            }
        })
        
        local Indicator = Create("Frame", {
            Parent = Tab.Button,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0.7, 0),
            Position = UDim2.new(0, 0, 0.15, 0),
            Children = {
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 3)
                })
            }
        })
        
        Create("TextLabel", {
            Parent = Tab.Button,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -12, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        Tab.Container = Create("ScrollingFrame", {
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        
        Create("UIListLayout", {
            Parent = Tab.Container,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        Create("UIPadding", {
            Parent = Tab.Container,
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 10)
        })
        
        Tab.Button.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(Tab.Button, {BackgroundColor3 = Theme.Surface}, 0.2)
            end
        end)
        
        Tab.Button.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(Tab.Button, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end
        end)
        
        Tab.Button.MouseButton1Click:Connect(function()
            Ripple(Tab.Button, Mouse.X, Mouse.Y)
            
            for _, t in pairs(Window.Tabs) do
                t.Container.Visible = false
                Tween(t.Button, {BackgroundColor3 = Theme.SurfaceLight}, 0.3)
                Tween(t.Button.TextLabel, {TextColor3 = Theme.TextDim}, 0.3)
                Tween(t.Button.Frame, {Size = UDim2.new(0, 0, 0.7, 0)}, 0.3)
            end
            
            Window.CurrentTab = Tab
            Tab.Container.Visible = true
            Tween(Tab.Button, {BackgroundColor3 = Theme.Surface}, 0.3)
            Tween(Tab.Button.TextLabel, {TextColor3 = Theme.Text}, 0.3)
            Tween(Indicator, {Size = UDim2.new(0, 3, 0.7, 0)}, 0.3, Enum.EasingStyle.Back)
        end)
        
        function Tab:AddSection(text)
            local Section = Create("Frame", {
                Parent = Tab.Container,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28)
            })
            
            Create("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = text:upper(),
                TextColor3 = Theme.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Create("Frame", {
                Parent = Section,
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -1),
                Size = UDim2.new(1, 0, 0, 1)
            })
            
            return Section
        end
        
        function Tab:AddButton(text, callback)
            local Button = Create("TextButton", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38),
                AutoButtonColor = false,
                Text = "",
                ClipsDescendants = true,
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            Create("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Create("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "→",
                TextColor3 = Theme.Accent,
                TextSize = 16
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(function()
                Ripple(Button, Mouse.X, Mouse.Y)
                Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.1)
                task.wait(0.15)
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.2)
                callback()
            end)
            
            return Button
        end
        
        function Tab:AddToggle(text, default, callback)
            local toggled = default or false
            
            local Toggle = Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            Create("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = Toggle,
                BackgroundColor3 = toggled and Theme.Accent or Theme.SurfaceLight,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -54, 0.5, -11),
                Size = UDim2.new(0, 44, 0, 22),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            local Knob = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            Create("UIStroke", {
                Parent = Knob,
                Color = Color3.fromRGB(0, 0, 0),
                Transparency = 0.9,
                Thickness = 1
            })
            
            local Button = Create("TextButton", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local function update()
                Tween(Switch, {BackgroundColor3 = toggled and Theme.Accent or Theme.SurfaceLight}, 0.3)
                Tween(Knob, {
                    Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                }, 0.4, Enum.EasingStyle.Back)
                
                if toggled then
                    Tween(Knob, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
                    task.wait(0.15)
                    Tween(Knob, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
                end
            end
            
            Button.MouseButton1Click:Connect(function()
                toggled = not toggled
                update()
                callback(toggled)
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(Toggle, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Toggle, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    update()
                    callback(toggled)
                end
            }
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            local value = default or min
            local dragging = false
            
            local Slider = Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 54),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            Create("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 6),
                Size = UDim2.new(1, -80, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -68, 0, 6),
                Size = UDim2.new(0, 60, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(value),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local Track = Create("Frame", {
                Parent = Slider,
                BackgroundColor3 = Theme.SurfaceLight,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 12, 1, -18),
                Size = UDim2.new(1, -24, 0, 6),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            local Fill = Create("Frame", {
                Parent = Track,
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            Create("UIGradient", {
                Parent = Fill,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Theme.AccentDark),
                    ColorSequenceKeypoint.new(1, Theme.Accent)
                })
            })
            
            local KnobOuter = Create("Frame", {
                Parent = Track,
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Position = UDim2.new((value - min) / (max - min), -10, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                ZIndex = 2,
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            local Knob = Create("Frame", {
                Parent = KnobOuter,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 12, 0, 12),
                ZIndex = 3,
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
            
            Create("UIStroke", {
                Parent = Knob,
                Color = Color3.fromRGB(0, 0, 0),
                Transparency = 0.8,
                Thickness = 1
            })
            
            local function update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                
                ValueLabel.Text = tostring(value)
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                Tween(KnobOuter, {Position = UDim2.new(pos, -10, 0.5, -10)}, 0.1)
                
                callback(value)
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Tween(KnobOuter, {Size = UDim2.new(0, 24, 0, 24)}, 0.2)
                    Tween(Knob, {Size = UDim2.new(0, 14, 0, 14)}, 0.2)
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    Tween(KnobOuter, {Size = UDim2.new(0, 20, 0, 20)}, 0.2)
                    Tween(Knob, {Size = UDim2.new(0, 12, 0, 12)}, 0.2)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            return {
                Set = function(val)
                    value = math.clamp(val, min, max)
                    ValueLabel.Text = tostring(value)
                    local pos = (value - min) / (max - min)
                    Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                    Tween(KnobOuter, {Position = UDim2.new(pos, -10, 0.5, -10)}, 0.2)
                    callback(value)
                end
            }
        end
        
        function Tab:AddDropdown(text, options, default, callback)
            local selected = default or options[1]
            local open = false
            
            local Dropdown = Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38),
                ClipsDescendants = true,
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            local Header = Create("TextButton", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Text = ""
            })
            
            Create("TextLabel", {
                Parent = Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -90, 0, 0),
                Size = UDim2.new(0, 70, 1, 0),
                Font = Enum.Font.Gotham,
                Text = selected,
                TextColor3 = Theme.Accent,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd
            })
            
            local Arrow = Create("TextLabel", {
                Parent = Header,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -18, 0, 0),
                Size = UDim2.new(0, 18, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "▼",
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Rotation = 0
            })
            
            local OptionContainer = Create("Frame", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 38),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            Create("UIListLayout", {
                Parent = OptionContainer,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            })
            
            Create("UIPadding", {
                Parent = OptionContainer,
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8)
            })
            
            for _, option in ipairs(options) do
                local OptionButton = Create("TextButton", {
                    Parent = OptionContainer,
                    BackgroundColor3 = option == selected and Theme.Accent or Theme.SurfaceLight,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    AutoButtonColor = false,
                    Text = "",
                    Children = {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 5)
                        })
                    }
                })
                
                Create("TextLabel", {
                    Parent = OptionButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                if option == selected then
                    Create("TextLabel", {
                        Parent = OptionButton,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -24, 0, 0),
                        Size = UDim2.new(0, 20, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "✓",
                        TextColor3 = Theme.Text,
                        TextSize = 14
                    })
                end
                
                OptionButton.MouseEnter:Connect(function()
                    if option ~= selected then
                        Tween(OptionButton, {BackgroundColor3 = Theme.Surface}, 0.2)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if option ~= selected then
                        Tween(OptionButton, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                    end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    ValueLabel.Text = option
                    
                    for _, btn in ipairs(OptionContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            Tween(btn, {BackgroundColor3 = Theme.SurfaceLight}, 0.2)
                            if btn:FindFirstChild("TextLabel") and btn.TextLabel:FindFirstChild("TextLabel") then
                                btn.TextLabel.TextLabel:Destroy()
                            end
                        end
                    end
                    
                    Tween(OptionButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Create("TextLabel", {
                        Parent = OptionButton,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -24, 0, 0),
                        Size = UDim2.new(0, 20, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "✓",
                        TextColor3 = Theme.Text,
                        TextSize = 14
                    })
                    
                    open = false
                    Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 38)}, 0.3)
                    Tween(Arrow, {Rotation = 0}, 0.3)
                    
                    callback(option)
                end)
            end
            
            Header.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    local targetSize = 38 + OptionContainer.AbsoluteSize.Y
                    Tween(Dropdown, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.3, Enum.EasingStyle.Back)
                    Tween(Arrow, {Rotation = 180}, 0.3)
                else
                    Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 38)}, 0.3)
                    Tween(Arrow, {Rotation = 0}, 0.3)
                end
            end)
            
            return {
                Set = function(val)
                    selected = val
                    ValueLabel.Text = val
                    callback(val)
                end
            }
        end
        
        function Tab:AddLabel(text)
            local Label = Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            local TextLabel = Create("TextLabel", {
                Parent = Label,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return {
                Set = function(txt)
                    TextLabel.Text = txt
                end
            }
        end
        
        function Tab:AddInput(text, placeholder, callback)
            local Input = Create("Frame", {
                Parent = Tab.Container,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 62),
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            })
            
            Create("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 6),
                Size = UDim2.new(1, -24, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Box = Create("TextBox", {
                Parent = Input,
                BackgroundColor3 = Theme.SurfaceLight,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 12, 1, -30),
                Size = UDim2.new(1, -24, 0, 26),
                Font = Enum.Font.Gotham,
                PlaceholderText = placeholder,
                PlaceholderColor3 = Theme.TextDim,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false,
                Children = {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 5)
                    }),
                    Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10)
                    })
                }
            })
            
            local Stroke = Create("UIStroke", {
                Parent = Box,
                Color = Theme.Border,
                Transparency = 0,
                Thickness = 1
            })
            
            Box.Focused:Connect(function()
                Tween(Stroke, {Color = Theme.Accent, Transparency = 0}, 0.2)
            end)
            
            Box.FocusLost:Connect(function()
                Tween(Stroke, {Color = Theme.Border, Transparency = 0}, 0.2)
                callback(Box.Text)
            end)
            
            return {
                Set = function(txt)
                    Box.Text = txt
                    callback(txt)
                end
            }
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            Tab.Button.MouseButton1Click()
        end
        
        return Tab
    end
    
    return Window
end

return Library
