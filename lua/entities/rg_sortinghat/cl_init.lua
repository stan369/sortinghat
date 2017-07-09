include('shared.lua')

local config = 
{
	--Textscreen 

	textscreen_color = Color(124, 21, 21, 255),
	-- Color of the textscreen that goes above the hat.

	textscreen_text = "Hat of Sorting",
	-- The text that is displayed above the hat.


	--Main Panel Config

	setpanel_draggable = false,
	-- Set if the main panel should be draggable or not.

	setpanel_mainColor = Color(40,40,40,150),
	-- The color of the main rectangle of the panel.

	setpanel_outlineColor = Color(20,20,20,225),
	-- The color of the outline of the main panel.

	openingText = "           Welcome to Hogwarts RolePlay!\nToday you will be sorted into your new House.",
	-- NOTE: The \n is to skip to the next line - you will have to do this when configurating.


	--Close Button

	closebutton_Color = Color(211, 62, 46,255),
	-- Color that displays when the Close button is not touched.

	closebutton_hoverColor = Color(232, 68, 51,255),
	-- Color that displays when someone has their mouse over the Close Button.

	closebutton_downColor = Color(255, 75, 56, 255),
	-- Color that displays when someone clicks the Close Button.

	closebutton_outlineColor = Color(50,50,50,255),
	-- Color that displays a thin outline around the Close button.


	--Sort Button

	sortbutton_text = "Sort Me!",
	-- The Text that displays in the sort button.

	notification_notGroup = "You are already in a House!",
	-- The legacy notification that pops up on the side when the button is pressed
	-- and the person is not a user

	sortbutton_hoverColor = Color(216, 216, 216, 255),
	-- Color that displays when someone has their mouse over the Sort Button.

	sortbutton_Color = Color(204, 204, 204, 255),
	-- Color that displays when the Sort button is not touched.

	sortbutton_downColor = Color(225, 225, 225, 255),
	-- Color that displays when someone clicks the Sort Button.

	sortbutton_outlineColor = Color(50,50,50,255)
	-- Color that displays a thin outline around the Sort button.
}



surface.CreateFont( "2d3dFont", {
	font = "Arial",
	extended = false,
	size =  ScreenScale(50),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "panelText", {
	font = "Arial",
	extended = false,
	size =  ScreenScale(9),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "buttonText", {
	font = "Arial",
	extended = false,
	size =  ScreenScale(7),
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

-- We WIll Not Provide Support If You Edit Beyond This Point!
function ENT:Draw()
	self:DrawModel()

	local function textscreen(degree)

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetAngles():Right(),degree)
	ang:RotateAroundAxis(self:GetAngles():Forward(),90)

	cam.Start3D2D(self:GetPos(),ang,0.1)

	draw.DrawText(config.textscreen_text,"2d3dFont",0,-300,config.textscreen_color,1)

	cam.End3D2D()
	end
	textscreen(90)
	textscreen(270)
end


net.Receive("sendDerma", function()

	local ply = LocalPlayer()

	--Main Panel
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW()*0.33,ScrH()*0.33)
	frame:SetSize(ScrW()*0.35+1,ScrH()*0.4+1)
	frame:MakePopup()
	frame:SetDraggable(config.setpanel_draggable)
	frame:SetTitle(" ")
	frame:ShowCloseButton(false)
	frame.Paint = function()
	surface.SetDrawColor(config.setpanel_outlineColor)
	surface.DrawOutlinedRect(0,0,frame:GetWide(),frame:GetTall())
	surface.SetDrawColor(config.setpanel_mainColor)
	surface.DrawRect(0,0,frame:GetWide() - 1,frame:GetTall() - 1)
	end

	--The main opening text in the main panel
	local text = vgui.Create("DLabel", frame)
	text:SetPos(ScrW()*0.053,ScrH()*0.02)
	text:SetSize(ScrW()*0.4,ScrH()*0.15)
	text:SetFont("panelText")
	text:SetText(config.openingText)

	--A way of bluring the background without frame.Paint interfering
	local blur = vgui.Create("DFrame")
	blur:SetSize(1,1)
	blur:SetDraggable(false)
	blur:SetBackgroundBlur(true)
	frame.OnRemove = function() --when the main panel closes, so does the blur
		blur:Close()
	end

	--Close button
	local cb = vgui.Create("DButton", frame)
	cb:SetSize(ScrW()*0.06+1,ScrH()*0.023+1)
	cb:SetPos(ScrW()*0.28,ScrH()*0.005)
	cb:SetText("")
	cb.DoClick = function()
		frame:Close()
	end
	cb.Paint = function()
		if cb:IsHovered() then
			surface.SetDrawColor(config.closebutton_hoverColor)
		else
			surface.SetDrawColor(config.closebutton_Color)
		end
		if cb:IsDown() then
			surface.SetDrawColor(config.closebutton_downColor)
		end
		surface.DrawRect(0,0,cb:GetWide() - 1,cb:GetTall() - 1)
		surface.SetDrawColor(config.closebutton_outlineColor)
		surface.DrawOutlinedRect(0,0,cb:GetWide(),cb:GetTall())
	end

local groupHouse = 
{
	{
		name = "hufflepuff"
	},
	{
		name = "gryffindor"
	},
	{
		name = "ravenclaw"
	},
	{
		name = "slytherin"
	}
}

	local groupText = vgui.Create("DLabel",frame)
	groupText:SetPos(ScrW()*0.085,ScrH()*0.13)
	groupText:SetSize(ScrW()*0.4,ScrH()*0.15)
	groupText:SetFont("panelText")
	groupText.Think = function()
		if ply:GetUserGroup() == "user" then
			groupText:SetPos(ScrW()*0.13,ScrH()*0.13)
			groupText:SetText("Your new House: ")
		end
		if ply:GetUserGroup() != "user" then
			groupText:SetPos(ScrW()*0.093,ScrH()*0.13)
			groupText:SetText("You are not of the four Houses!")
		end
		for k,v in pairs(groupHouse) do
			if ply:GetUserGroup() == v.name then
				groupText:SetPos(ScrW()*0.1,ScrH()*0.13)
				groupText:SetText(" Your new House: " .. tostring( ply:GetUserGroup() ) .. "!")
			end
		end
	end

	--Sort Button
	local sb = vgui.Create("DButton", frame)
	sb:SetSize(ScrW()*0.07+1,ScrH()*0.05+1)
	sb:SetPos(ScrW()*0.142,ScrH()*0.3)
	sb:SetText(config.sortbutton_text)

	sb.DoClick = function()
		if ply:GetUserGroup() != "user" then
			notification.AddLegacy(config.notification_notGroup,NOTIFY_HINT,3)
		end

		net.Start("selectGroup")
		net.SendToServer()
	end
	sb.PerformLayout = function()
		sb:SetFontInternal("buttonText")
	end


	sb.Paint = function()
		if sb:IsHovered() then
			surface.SetDrawColor(config.sortbutton_hoverColor)
		else
			surface.SetDrawColor(config.sortbutton_Color)
		end
		if sb:IsDown() then
			surface.SetDrawColor(config.sortbutton_downColor)
		end

		surface.DrawRect(0, 0, sb:GetWide() - 1,sb:GetTall() - 1)
		surface.SetDrawColor(config.sortbutton_outlineColor)
		surface.DrawOutlinedRect(0, 0, sb:GetWide(), sb:GetTall())
	end
end)

