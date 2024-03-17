---- ###############################################################################################################################################################################################
---- KBI Battery Monitor Lua Script Widget Version 3/11/24
---- This Telemetry Widget Will Monitor Flight Pack Voltage and Flight Time As Follows:
---- 1. Annunciates Remaining Battery Pecentage when Battery is First Connected to the Model and Resets Timer to Zero
---- 2. If Initial Battery Is Less than the Initial Low Battery Percentage warning, Annunciate Beep, Low Battery, and Remaining Battery Percentage (Default = 50%)
---- 3. Displays the Highest Voltage Within the Number of Defined 1-Second Samples (Default 8-Seconds)
---- 4. Annunciates Remaining Battery Percentage and Flight Time When Battery Is Not Low (Defalt 30-Seconds)
---- 5. Annunciates Beep, Remaining Battery Percentage, and Flight Time When Battery is Low (Default 15-Seconds)
---- 6. Flight Time Increments Every Second When Armed
---- 7. Reset Flight Time Based On the Defined Switch and When Battery is Connected

----***** Adjust These Variables For Your Model ******                                                                
local	ARMSWITCH = "sh"		--Enter Switch that Enables Arming.  When Disarmed Flight Time Will Not Increment and Audio Messages Are Disabled
local   FLIGHTTIMERESET = "sc"		--Enter Switch that Resets Flight Time
local	TELEMSENSOR = "VFAS"		--Enter Name of Flight Pack Voltage Telemetry Sensor (RxBt/A1/A2/A3/VFAS/RxBt/etc..)
local   SAMPLESIZE = 8			--Number of 1-Second Voltage Samples (Default Value = 8)
local	CELLSINPACK = 6			--Number of Cells In Pack         
local	ANNUNCIATESEC = 30		--Number of Seconds to Annunciate Battery Percentage and Flight Time When Battery Is Not Low (Default Value = 30)
local	ANNUNCIATELOWBATTSEC = 10	--Number of Seconds to Annunciate Beep, Low Battery Percentage, and Flight Time When Battery At or Below Low Battery Percentage (Default Value = 15)
local	LOWBATTPERCENT = 8		--Remaining Battery Percent to Start Low Battery Annunciation (Default = 8%)       
local	INITIALLOWBATTPERCENT = 50	--Initial Low Battery Warning When Battery if First Connected (Default = 50%)              
---- ###############################################################################################################################################################################################

local options = {
  { "Color", COLOR, COLOR_THEME_SECONDARY1 },
  { "Shadow", BOOL, 0 }
}
local bootupcomplete = 0
local currentvbat = 0
local vbatread = 0
local lastupdate = 0
local vbat = 0
local battArray = {}
local battIndex = 0
local result = 0
local flightTime = 0
local annunciateTime = 0
local previousresult = 0
local previousresultcount = 0
local myArrayPercentList = { { 3, 0 }, { 3.093, 1 }, { 3.196, 2 }, { 3.301, 3 }, { 3.401, 4 }, { 3.477, 5 }, { 3.544, 6 }, { 3.601, 7 }, { 3.637, 8 }, { 3.664, 9 }, { 3.679, 10 }, { 3.683, 11 }, { 3.689, 12 }, { 3.692, 13 }, { 3.705, 14 }, { 3.71, 15 }, { 3.713, 16 }, { 3.715, 17 }, { 3.72, 18 }, { 3.731, 19 }, { 3.735, 20 }, { 3.744, 21 }, { 3.753, 22 }, { 3.756, 23 }, { 3.758, 24 }, { 3.762, 25 }, { 3.767, 26 }, { 3.774, 27 }, { 3.78, 28 }, { 3.783, 29 }, { 3.786, 30 }, { 3.789, 31 }, { 3.794, 32 }, { 3.797, 33 }, { 3.8, 34 }, { 3.802, 35 }, { 3.805, 36 }, { 3.808, 37 }, { 3.811, 38 }, { 3.815, 39 }, { 3.818, 40 }, { 3.822, 41 }, { 3.825, 42 }, { 3.829, 43 }, { 3.833, 44 }, { 3.836, 45 }, { 3.84, 46 }, { 3.843, 47 }, { 3.847, 48 }, { 3.85, 49 }, { 3.854, 50 }, { 3.857, 51 }, { 3.86, 52 }, { 3.863, 53 }, { 3.866, 54 }, { 3.87, 55 }, { 3.874, 56 }, { 3.879, 57 }, { 3.888, 58 }, { 3.893, 59 }, { 3.897, 60 }, { 3.902, 61 }, { 3.906, 62 }, { 3.911, 63 }, { 3.918, 64 }, { 3.923, 65 }, { 3.928, 66 }, { 3.939, 67 }, { 3.943, 68 }, { 3.949, 69 }, { 3.955, 70 }, { 3.961, 71 }, { 3.968, 72 }, { 3.974, 73 }, { 3.981, 74 }, { 3.987, 75 }, { 3.994, 76 }, { 4.001, 77 }, { 4.007, 78 }, { 4.014, 79 }, { 4.021, 80 }, { 4.029, 81 }, { 4.036, 82 }, { 4.044, 83 }, { 4.052, 84 }, { 4.062, 85 }, { 4.074, 86 }, { 4.085, 87 }, { 4.095, 88 }, { 4.105, 89 }, { 4.111, 90 }, { 4.116, 91 }, { 4.12, 92 }, { 4.125, 93 }, { 4.129, 94 }, { 4.135, 95 }, { 4.145, 96 }, { 4.176, 97 }, { 4.179, 98 }, { 4.193, 99 }, { 4.2, 100 }, { 4.215, 101 }, { 4.23, 102 }, { 4.245, 103 }, { 4.26, 104}, { 4.275, 105 }, { 4.29, 106 }, { 4.305, 107 }, { 4.32, 108 }, { 4.335, 109 }, { 4.36, 110 }, {4.36, 110 }   }


local function create(zone, options)
  local battmonitor = { zone=zone, options=options, BattMon="Battery: 0%\nTime: 00:00" }	
  for i = 0, SAMPLESIZE, 1 do
	battArray[i] = 0
  end
  return battmonitor
end
local function update(battmonitor, options)
  battmonitor.options = options
end
local function process()
	if getValue(FLIGHTTIMERESET) >= 0 then
		flightTime = 0
		annunciateTime = 0
	end
	vbatread = getValue(TELEMSENSOR)
	--Keep Highest Read Voltage For Each Second
	if vbatread > currentvbat then
		currentvbat = vbatread
	end
	if not(lastupdate == getRtcTime())  then
		lastupdate = getRtcTime()
		battArray[battIndex] = currentvbat
		currentvbat = 0
		if bootupcomplete == 1 then
			battIndex = battIndex + 1
			if battIndex > SAMPLESIZE -1 then
				battIndex = 0
			end
		end
		--Find Max Value Within Last SAMPLESIZE Default = 8-Seconds
		vbat = 0
		for i = 0, SAMPLESIZE, 1 do
			if battArray[i] > vbat then
				vbat = battArray[i]
			end
		end
  		for i, v in ipairs(myArrayPercentList) do
    			if v[1] >= vbat/CELLSINPACK then
      				result = v[2]
      				break
    			end
		end						
		if result == 0 then
			previousresult = 0
			bootupcomplete = 0
			previousresultcount = 0
		end
		if bootupcomplete == 0 and result > 0 then
			if previousresult > 0 and result <= previousresult then
				previousresultcount = previousresultcount + 1
			end
			previousresult = result
			--When Battery Is First Connected Wait a Few Cycles With Same Result to Get Full Voltage Before Annunication
			if previousresultcount >= 5 then
				flightTime = 0
				annunciateTime = 0
				bootupcomplete = 1
				if result <= 50 then
					playTone(0,250,PLAY_NOW)
					playFile("/SOUNDS/en/lowbat.wav")			
				end
				playNumber(result,0)
				playFile("/SOUNDS/en/system/percent0.wav")
			end	
		--elseif getLogicalSwitchValue(0) then
		elseif getValue(ARMSWITCH) < 0 then
			flightTime = flightTime + 1
			annunciateTime = annunciateTime + 1
			if annunciateTime >= ANNUNCIATESEC or (annunciateTime >= ANNUNCIATELOWBATTSEC and result <= LOWBATTPERCENT) then
				annunciateTime = 0
				if result <= LOWBATTPERCENT then
					playTone(0,200,PLAY_NOW)
				end	
			
				playNumber(result,0)
				playFile("/SOUNDS/en/system/percent0.wav")
				
				if math.floor(flightTime/60) > 0 then
					playNumber(math.floor(flightTime/60),0)
					playFile("/SOUNDS/en/system/minute1.wav")
				end
				playNumber(math.floor(flightTime%60),0)
				playFile("/SOUNDS/en/system/second1.wav")
			end
		end
  	end	
	return
end

local function background(battmonitor)
	process()
	battmonitor.BattMon = "Battery: " .. result .. "%" .. "\nTime: " .. string.format("%02d",math.floor(flightTime/60)) .. ":" .. string.format("%02d",math.floor(flightTime%60))
  	lcd.setColor(CUSTOM_COLOR, battmonitor.options.Color)
 	if battmonitor.options.Shadow == 0 then
   		lcd.drawText(battmonitor.zone.x, battmonitor.zone.y, battmonitor.BattMon, LEFT + DBLSIZE + CUSTOM_COLOR);
  	else
    		lcd.drawText(battmonitor.zone.x, battmonitor.zone.y, battmonitor.BattMon, LEFT + DBLSIZE + CUSTOM_COLOR + SHADOWED);
  	end
end

function refresh(battmonitor)
	process()
	battmonitor.BattMon = "Battery: " .. result .. "%" .. "\nTime: " .. string.format("%02d",math.floor(flightTime/60)) .. ":" .. string.format("%02d",math.floor(flightTime%60))
  	lcd.setColor(CUSTOM_COLOR, battmonitor.options.Color)
 	if battmonitor.options.Shadow == 0 then
   		lcd.drawText(battmonitor.zone.x, battmonitor.zone.y, battmonitor.BattMon, LEFT + DBLSIZE + CUSTOM_COLOR);
  	else
    		lcd.drawText(battmonitor.zone.x, battmonitor.zone.y, battmonitor.BattMon, LEFT + DBLSIZE + CUSTOM_COLOR + SHADOWED);
  	end
end

return { name="BattMon", options=options, create=create, update=update, refresh=refresh, background=background }
