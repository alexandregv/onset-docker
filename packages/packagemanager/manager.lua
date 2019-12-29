Package_Manager = {
	debug = true
}

function Package_Manager.FindPackage(package)
	_package = false
	for i, _p in pairs(GetAllPackages()) do
		if (_p == package) then
			_package = _p
			break
		end
	end

	return _package and true or false
end

function Package_Manager.Output(player,message)
	print(message)
	AddPlayerChat(player, message)
end

function Package_Manager.Debugger(message)
	if not Package_Manager.debug then return end

	print(message)
	AddPlayerChatAll(message)
end
AddEvent("OnScriptError",Package_Manager.Debugger)

AddCommand("debugscript",
	function(player) 
		Package_Manager.debug = not Package_Manager.debug --Flip the bool!
		AddPlayerChat(player, "Debug "..(Package_Manager.debug and "enabled" or "disabled"))
	end
)

function Package_Manager.Handler(player,package,task)
	if not player or not IsValidPlayer(player) then return end
	if not package or type(package) ~= "string" or not (#package >= 1) then return end

	-- ADMIN CHECK - Change this section of the code if you want to restrict players from using this. Example below.
	--if not (GetPlayerPropertyValue(player,"admin") >= 1) then return end

	-- Check packages that are available and find the one that's been sent through
	
	-- Do task based on task (catchy aint it? :D)
	if task == "start" then
		if IsPackageStarted(package) then return Package_Manager.Output(player, "Package "..package.." is already running.") end
		
		Package_Manager.Output(player, "Starting "..package..", please wait...")
		if StartPackage(package) then
			return Package_Manager.Output(player, "Package "..package.." has started.")
		else
			-- Check FindPackage to be sure
			if (Package_Manager.FindPackage(package)) then
				return Package_Manager.Output(player, "An error occured while starting "..package..", please check console.") --Package found, clearly an error.
			else
				return Package_Manager.Output(player, "Package "..package.." does not exist.")
			end
		end
	elseif task == "stop" then
		if not IsPackageStarted(package) then return Package_Manager.Output(player, "Package "..package.." is not running.") end
		
		Package_Manager.Output(player, "Stopping "..package..", please wait...")
		if StopPackage(package) then
			Package_Manager.Output(player, "Package "..package.." has stopped.")
		else
			-- Package exist?
			if (Package_manager.FindPackage(package)) then
				return Package_Manager.Output(player, "An error occured while stopping "..package..". Please check server logs as it may indicate an issue.")
			else
				return Package_Manager.Output(player, "Package "..package.." does not exist.")
			end
		end
	elseif task == "restart" then
		if not IsPackageStarted(package) then return Package_Manager.Output(player, "Package "..package.." is not running.") end
		
		Package_Manager.Output(player, "Restarting "..package..", please wait...")
		StopPackage(package)
		if not (StartPackage(package)) then
			-- Package exist?
			if (Package_Manager.FindPackage(package)) then
				return Package_Manager.Output(player, "An error occured while restarting "..package..". Please check server log as it may indicate a script error.")
			else
				return Package_Manager.Output(player, "Package "..package.." does not exist.")
			end
		end
		--Server announces package has started anyways.
	end
end
AddCommand("start", function(player,package) Package_Manager.Handler(player,package,"start") end)
AddCommand("stop", function(player,package) Package_Manager.Handler(player,package,"stop") end)
AddCommand("restart", function(player,package) Package_Manager.Handler(player,package,"restart") end)
