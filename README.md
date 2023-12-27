**Displays and Annunciates Flight Time and Remaining Battery Percentage**

This **Telemetry Widget** Will Monitor Flight Pack Voltage and Flight Time As Follows:
1. Reports the Highest Voltage Within the Number of Defined 1-Second Samples (Default 8-Seconds)
2. Annunciates the Remaining Battery Percentage and Flight Time When Battery Is Not Low (Default Duration is 30-Seconds)
3. Annunciates Beep, Remaining Battery Percentage, and Flight Time When Battery is Low (Default Duration is 15-Seconds)
4. Flight Time Increments Every Second When Armed
5. Reset Flight Time Based On the Defined Switch

All **tuning variables** are at the top of the script as follows:
1. local	ARMSWITCH = "sh"		      --Enter Switch that Enables Arming.  When Disarmed Flight Time Will Not Increment and Audio Messages Are Disabled

2. local FLIGHTTIMERESET = "sc"    --Enter Switch that Resets Flight Time

3. local	TELEMSENSOR = "EVIN"		  --Enter Name of Flight Pack Voltage Telemetry Sensor (RxBt/A1/A2/A3/VFAS/RxBt/etc..)

4. local SAMPLESIZE = 8			      --Number of 1-Second Voltage Samples (Default Value = 8)

5. local	CELLSINPACK = 6			      --Number of Cells In Pack         

6. local	ANNUNCIATESEC = 30		    --Number of Seconds to Annunciate Battery Percentage and Flight Time When Battery Is Not Low (Default Value = 30)

7. local	ANNUNCIATELOWBATTSEC = 15	--Number of Seconds to Annunciate Beep, Low Battery Percentage, and Flight Time When Battery At or Below Low Battery Percentage (Default Value = 15)

8. local	LOWBATTPERCENT = 25		     --Remaining Battery Percent to Start Low Battery Annunciation (Default = 25%)    

**Installation Instructions:** 
1. Create a new folder (BattMon) on the radio SD Card  \WIDGETS\BattMon
2. Place the BattMon.lua file in the BattMon folder
3. When radio restarts for the first time after the file is copied, it will compile the script and create a BattMon.luac file
4. If the tuning variables are updated, you must delete the BattMon.luac file so the updated file will be recompiled
