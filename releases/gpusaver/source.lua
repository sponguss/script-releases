local CoreGui = game:GetService("CoreGui")

if type(gethui) == 'function' then
	CoreGui = gethui()
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = 'CPUSaver'
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextStrokeTransparency = 1
TextLabel.AnchorPoint = Vector2.new(.5, .5)
TextLabel.Position = UDim2.fromScale(.5, .5)
TextLabel.Size = UDim2.fromScale(1.5, 1.5)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.TextSize = 24
TextLabel.Text = "GPU Saver is enabled.\n\nPress any key to disable manually.\nTo disable this entirely, run _G.DisableGPUSaver()"
TextLabel.Parent = ScreenGui

local Connections = {}
local Signals = {RunService.Stepped, RunService.RenderStepped}

local cansetfpscap = type(setfpscap) == 'function'
local cangetconnections = type(getconnections) == 'function'

local function pause()
	if cansetfpscap then
		setfpscap(15)
	end
	ScreenGui.Enabled = true
	RunService:Set3dRenderingEnabled(false)
	if cangetconnections then
		for _, x in pairs(Signals) do
			for _, v in pairs(getconnections(x)) do
				v:Disable()
				table.insert(Connections, v)
			end
		end
	end
	paused = true
end

local function resume()
	if cansetfpscap then
		setfpscap(1000)
	end
	ScreenGui.Enabled = false
	RunService:Set3dRenderingEnabled(true)
	if cangetconnections then
		for i, v in pairs(Connections) do
			v:Enable()
			Connections[i] = nil
		end
	end
	paused = false
end

local con0 = UserInputService.WindowFocusReleased:Connect(pause)
local con1 = UserInputService.WindowFocused:Connect(resume)
local con2 = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if paused and input.UserInputState == Enum.UserInputState.Begin and input.UserInputType == Enum.UserInputType.Keyboard then
		resume()
	end
end)

--- Disable the GPU saver.
--- @type function
_G.DisableGPUSaver = function()
	resume()
	con0:Disconnect()
	con1:Disconnect()
	con2:Disconnect()
end
