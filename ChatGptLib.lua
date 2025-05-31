local Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

local Themes = {
	LightTheme = Color3.fromRGB(240, 240, 240),
	DarkTheme = Color3.fromRGB(20, 20, 20),
	GrapeTheme = Color3.fromRGB(100, 0, 150),
	BloodTheme = Color3.fromRGB(180, 0, 0),
	Ocean = Color3.fromRGB(0, 90, 180),
	Midnight = Color3.fromRGB(25, 25, 112),
	Sentinel = Color3.fromRGB(58, 0, 110),
	Synapse = Color3.fromRGB(32, 32, 32)
}

function Library.CreateLib(title, themeName)
	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = title
	MainFrame.Size = UDim2.new(0, 500, 0, 350)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
	MainFrame.BackgroundColor3 = Themes[themeName] or Themes.DarkTheme
	MainFrame.Active = true
	MainFrame.Draggable = true

	local Tabs = {}
	local UI = {}

	function UI:NewTab(name)
		local TabButton = Instance.new("TextButton", MainFrame)
		TabButton.Size = UDim2.new(0, 100, 0, 30)
		TabButton.Text = name
		TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		
		local TabFrame = Instance.new("Frame", MainFrame)
		TabFrame.Name = name
		TabFrame.Size = UDim2.new(1, -110, 1, -40)
		TabFrame.Position = UDim2.new(0, 110, 0, 40)
		TabFrame.Visible = false

		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Tabs) do tab.Visible = false end
			TabFrame.Visible = true
		end)

		Tabs[#Tabs + 1] = TabFrame

		local SectionAPI = {}

		function SectionAPI:NewSection(title)
			local Section = Instance.new("Frame", TabFrame)
			Section.Size = UDim2.new(1, -10, 0, 200)
			Section.BackgroundTransparency = 1

			local Title = Instance.new("TextLabel", Section)
			Title.Text = title
			Title.Size = UDim2.new(1, 0, 0, 20)
			Title.BackgroundTransparency = 1
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextXAlignment = Enum.TextXAlignment.Left

			local function AddComponent(component)
				component.Position = UDim2.new(0, 0, 0, #Section:GetChildren() * 30)
				component.Parent = Section
			end

			local SecAPI = {}

			function SecAPI:UpdateSection(newTitle)
				Title.Text = newTitle
			end

			function SecAPI:NewLabel(text)
				local lbl = Instance.new("TextLabel")
				lbl.Text = text
				lbl.Size = UDim2.new(1, 0, 0, 25)
				lbl.BackgroundTransparency = 1
				lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				AddComponent(lbl)

				return {
					UpdateLabel = function(_, newText)
						lbl.Text = newText
					end
				}
			end

			function SecAPI:NewButton(text, info, callback)
				local btn = Instance.new("TextButton")
				btn.Text = text
				btn.Size = UDim2.new(1, 0, 0, 25)
				btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(btn)

				btn.MouseButton1Click:Connect(callback)

				return {
					UpdateButton = function(_, newText)
						btn.Text = newText
					end
				}
			end

			function SecAPI:NewToggle(text, info, callback)
				local toggled = false
				local btn = Instance.new("TextButton")
				btn.Text = "[OFF] " .. text
				btn.Size = UDim2.new(1, 0, 0, 25)
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(btn)

				btn.MouseButton1Click:Connect(function()
					toggled = not toggled
					btn.Text = (toggled and "[ON] " or "[OFF] ") .. text
					callback(toggled)
				end)

				return {
					UpdateToggle = function(_, newText)
						btn.Text = (toggled and "[ON] " or "[OFF] ") .. newText
					end
				}
			end

			function SecAPI:NewSlider(text, info, max, min, callback)
				local slider = Instance.new("TextButton")
				slider.Text = text .. ": " .. min
				slider.Size = UDim2.new(1, 0, 0, 25)
				slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				slider.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(slider)

				local val = min
				slider.MouseButton1Click:Connect(function()
					val = val + 1
					if val > max then val = min end
					slider.Text = text .. ": " .. val
					callback(val)
				end)
			end

			function SecAPI:NewTextBox(text, info, callback)
				local box = Instance.new("TextBox")
				box.PlaceholderText = text
				box.Size = UDim2.new(1, 0, 0, 25)
				box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				box.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(box)

				box.FocusLost:Connect(function()
					callback(box.Text)
				end)
			end

			function SecAPI:NewKeybind(text, info, key, callback)
				local label = Instance.new("TextLabel")
				label.Text = text .. " [" .. tostring(key) .. "]"
				label.Size = UDim2.new(1, 0, 0, 25)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(label)

				UIS.InputBegan:Connect(function(input)
					if input.KeyCode == key then
						callback()
					end
				end)
			end

			function SecAPI:NewDropdown(text, info, list, callback)
				local dropdown = Instance.new("TextButton")
				dropdown.Text = text .. ": " .. list[1]
				dropdown.Size = UDim2.new(1, 0, 0, 25)
				dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
				AddComponent(dropdown)

				local index = 1
				dropdown.MouseButton1Click:Connect(function()
					index = index % #list + 1
					dropdown.Text = text .. ": " .. list[index]
					callback(list[index])
				end)

				return {
					Refresh = function(_, newList)
						list = newList
						index = 1
						dropdown.Text = text .. ": " .. list[1]
					end
				}
			end

			function SecAPI:NewColorPicker(text, info, defaultColor, callback)
				local btn = Instance.new("TextButton")
				btn.Text = text
				btn.BackgroundColor3 = defaultColor
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
				btn.Size = UDim2.new(1, 0, 0, 25)
				AddComponent(btn)

				btn.MouseButton1Click:Connect(function()
					local rand = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
					btn.BackgroundColor3 = rand
					callback(rand)
				end)
			end

			return SecAPI
		end

		return SectionAPI
	end

	function UI:ToggleUI()
		MainFrame.Visible = not MainFrame.Visible
	end

	return UI
end

return Library
