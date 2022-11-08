local module = {}

function module:FindTimeToReach(shooterPosition, targetPosition, projectileSpeed, gravity)
	local distance = (targetPosition - shooterPosition).Magnitude
	local timeTaken = (distance / projectileSpeed)

	if gravity > 0 then
		local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
	end
	
	return timeTaken
end

function module:FindMaximumRange(projectileSpeed, gravity, initialheight)
	local angle = math.rad(45)
	local cos = math.cos(angle)
	local sin = math.sin(angle)

	local range = (projectileSpeed*cos/gravity) * (projectileSpeed*sin + math.sqrt(projectileSpeed*projectileSpeed*sin*sin + 2*gravity*initialheight))
	return range
end

function module:FindAngleToShootAt(origin, projectileSpeed, targetPosition, gravity)
	local diff = targetPosition - origin
	local diffXZ = Vector3.new(diff.x, 0, diff.z)

	local groundDist = -diffXZ.Magnitude

	local speed2 = projectileSpeed^2
	local speed4 = projectileSpeed^4
	local y = diff.y
	local x = groundDist
	local gx = gravity*x

	local root = speed4 - gravity*(gravity*x*x + 2*y*speed2)
	
	if (root < 0) then
		return 0, 0
	end

	root = math.sqrt(root)
	local lowAng = math.atan2(speed2 - root, gx)
	local highAng = math.atan2(speed2 + root, gx)

	local groundDir = diffXZ.Unit
	local s0 = groundDir*math.cos(lowAng)*projectileSpeed + Vector3.new(0,1,0)*math.sin(lowAng)*projectileSpeed
	local s1 = groundDir*math.cos(highAng)*projectileSpeed + Vector3.new(0,1,0)*math.sin(highAng)*projectileSpeed

	return math.deg(lowAng), math.deg(highAng)
end

function module:FindLeadShot(targetPosition: Vector3, targetVelocity: Vector3, projectileSpeed: Number, shooterPosition: Vector3, shooterVelocity: Vector3, gravity: Number)	
	local distance = (targetPosition - shooterPosition).Magnitude

	local p = targetPosition - shooterPosition
	local v = targetVelocity - shooterVelocity
	local a = Vector3.new(0, math.abs(gravity), 0)

	local timeTaken = (distance / projectileSpeed)
	
	if gravity > 0 then
		local timeTaken = projectileSpeed/gravity+math.sqrt(2*distance/gravity+projectileSpeed^2/gravity^2)
	end

	local goalX = targetPosition.X + v.X*timeTaken + 0.5 * a.X * timeTaken^2
	local goalY = targetPosition.Y + v.Y*timeTaken + 0.5 * a.Y * timeTaken^2
	local goalZ = targetPosition.Z + v.Z*timeTaken + 0.5 * a.Z * timeTaken^2
	
	return Vector3.new(goalX, goalY, goalZ)
end

return module
