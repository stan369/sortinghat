AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.AddNetworkString("sendDerma")
util.AddNetworkString("selectGroup")

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 25
	local ent = ents.Create( "rg_sortinghat" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel( rg_hatmodel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( ent, ply )
	net.Start("sendDerma")
	net.Send(ply)
end

net.Receive("selectGroup", function(len, ply)
	if ply:IsValid() and ply:GetUserGroup() == "user" then
		local chosen = table.Random(rg_listOfHouses)
		ulx.adduser(ply, ply, chosen.ulx)
		ply:changeTeam(chosen.job, true)
	end
end)


