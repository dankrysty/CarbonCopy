::=================================================================::
::CarbonCopy Migration V1.0                                                  ::
::Created by Daniel Krysty                                         ::
::robocopy to move large data files from one location to another   ::
::Built in error checking                                          ::
::November 2023                                                    ::
::=================================================================::      
    
copyIt.bat needs to be run with elevation to move files and directories to destination. 

---------------------------------------------------------------------------------------------------------


net use command may be needed for allowing access on network shares
::=============::
:: FOR NET USE ::
::=============::
get access to share folder for log.txt
get access to source and destination locations with net use

look for:
:: **Uncomment the lines below for net file share access... may require credentials**
uncomment lines in section
**this is still in beta testing**

---------------------------------------------------------------------------------------------------------

type in >>cd "path_to_directory"
type in >>CarbonCopy.bat %source% %destination%

SHIFT+Right Click on folder for source and choose "Copy as Path" paste path in prompt then do the same for destination

It will display main contents of source and destination to help verify before you continue

Then it will ask to continue (y/n) - Defualt is "n"
y/Y - copy and log data in log.txt
n/N - cancel and exit
other - invalid

Example:
CarbonCopy.bat "C:\Users\x0001234\Desktop\SourceFolder" "C:\Users\a0000123\Desktop\DestFolder"

---------------------------------------------------------------------------------------------------------

[First Number is section][Second number is location in that section] i.e. 12 = Section 1, Error Location 2
ERROR CODES:
00 - No Error.
01 - Origin Location OR Target Location invalid or inaccessible.
02 - Origin Location AND Target Location invalid or inaccessible.
11 - User cancelation "n or N" when asked to continue.
12 - User error not valid choice to continue "y, Y, n, or N".
21 - No log file detected. Creating one so it can log details.

---------------------------------------------------------------------------------------------------------
