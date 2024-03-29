**Displays and Annunciates Flight Time and Remaining Battery Percentage**

This **Telemetry Widget** Will Monitor Flight Pack Voltage and Flight Time As Follows:
 1. Annunciates Remaining Battery Pecentage when Battery is First Connected to the Model and Resets Timer to Zero
 2. If Initial Battery Is Less than the Initial Low Battery Percentage warning, Annunciate Beep, Low Battery, and Remaining Battery Percentage (Default = 50%)
 3. Displays the Highest Voltage Within the Number of Defined 1-Second Samples (Default 8-Seconds)
 4. Annunciates Remaining Battery Percentage and Flight Time When Battery Is Not Low
 5. Annunciates Beep, Remaining Battery Percentage, and Flight Time When Battery is Low
 6. Flight Time Increments Every Second When Armed
 7. Reset Flight Time Based On the Defined Switch

All **tuning variables** are at the top of the script as follows:
1.	ARMSWITCH = "sh"		    --Enter Switch that Enables Arming.  When Disarmed Flight Time Will Not Increment and Audio Messages Are Disabled
2.  FLIGHTTIMERESET = "sc"	--Enter Switch that Resets Flight Time
3.	TELEMSENSOR = "VFAS"		--Enter Name of Flight Pack Voltage Telemetry Sensor (RxBt/A1/A2/A3/VFAS/EVIN/RxBt/etc..)
4.  SAMPLESIZE = 8			    --Number of 1-Second Voltage Samples (Default Value = 8)
5.	CELLSINPACK = 6			     --Number of Cells In Pack         
6.	ANNUNCIATESEC = 30		   --Number of Seconds to Annunciate Battery Percentage and Flight Time When Battery Is Not Low (Default Value = 30)
7.	ANNUNCIATELOWBATTSEC = 10	--Number of Seconds to Annunciate Beep, Low Battery Percentage, and Flight Time When Battery At or Below Low Battery Percentage (Default Value = 10)
8.	LOWBATTPERCENT = 8		--Remaining Battery Percent to Start Low Battery Annunciation (Default = 8%)       
9.	INITIALLOWBATTPERCENT = 50	--Initial Low Battery Warning when Battery is First Connected (Default = 50%)      

**Installation Instructions:** 
1. Create a new folder (BattMon) on the radio SD Card  \WIDGETS\BattMon
2. Place the BattMon.lua file in the BattMon folder
3. When radio restarts for the first time after the file is copied, it will compile the script and create a BattMon.luac file
