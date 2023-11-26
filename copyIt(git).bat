::=================================================================::
::Created by Daniel Krysty                                         ::
::robocopy to move large data files from one location to another   ::
::Built in error checking                                          ::
::November 2023                                                    ::
::=================================================================::     
        
:: echo is turned off 
@echo off
:: clear screen
cls
:: set local vars
setlocal

:: get value for arg1=source and arg2=dest
set source="%1"
set dest="%2"
set logFile=.\log.txt

::=============::
:: FOR NET USE ::
::=============::
:: get access to share folder for log.txt
:: get access to source and destination locations with net use

:: **Uncomment the lines below for net file share access... may require credentials**
:: net use %source%
:: net use %dest%

:: Get threadinng on processor to maximize performance
set /a threads=%NUMBER_OF_PROCESSORS%
set /a useThreads="threads - 4"
:: set error code
set errorCode=00
:: see README.txt for debug error codes

:: Start Header for terminal
:: show user, date, and time 
echo User Info:
echo ----------
whoami
hostname
date /t
time /t
echo:
echo :::::::::::::::::::::::::::::::::::::
echo ::        Using CopyIt.bat         ::
echo ::  a tool used for data transfer  ::
echo :::::::::::::::::::::::::::::::::::::
echo:
:: Show log file location
echo Log file located at %logFile%
echo:
:: Show Processor threading information
echo **IMPORTANT**
echo ** There are %threads% threads available
echo ** %useThreads% threads will be used for data transfer
echo:
:: Show source and destination locations
echo Attempting to set source location to: %source%
echo Attempting to set destination location to: %dest%
echo:
echo ------------------------------------------------------
echo:
:: End Header


:: Start Main 
:: Section 0
if exist %source% (
	echo Source location test successful.
	echo:
	if exist %dest% (
		echo Destination location test successful.
		echo:
		echo ------------------------------------------------------
		call :showContents
		call :userInput
		call :doContinue
		goto :eof
	) else (
		echo Destination location test unsuccessful.
		set errorCode=01
		goto :errorMessage
	)
) else (
	echo Source location test unsuccessful.
	echo:
	if exist %dest% (
		echo Destination location test successful.
		echo:
		set errorCode=01
		goto :errorMessage
	) else (
		echo Destination location test unsuccessful.
		set errorCode=02
		goto :errorMessage
	)
)
:: End Main

::===========::
:: FUNCTIONS ::
::===========::
:showContents
echo:
echo SOURCE
echo FOLDERS
echo -------
dir %source% /a /b /a:d
echo:
echo SOURCE
echo FILES
echo -------
dir %source% /a /b /a:-d
echo:
echo ------------------------------------------------------
echo:
echo DESTINATION
echo FOLDERS
echo -------
dir %dest% /a /b /a:d
echo:
echo DESTINATION
echo FILES
echo -------
dir %dest% /a /b /a:-d 
echo:
echo ------------------------------------------------------
echo:
exit /b 0

:userInput
echo:
set cont=n
set /p "cont=Do you want to proceed? (y/n) or hit ENTER to exit: "
echo:
exit /b 0
target 
:doContinue
:: Section 1
if %cont% == y (
	goto :checkLog
)else if %cont% == Y (
	goto :checkLog
)else if %cont% == n (
	echo Canceling and exiting...
	set errorCode=11
	goto :errorMessage
)else if %cont% == N (
	echo Canceling and exiting...
	set errorCode=11
	goto :errorMessage
)else (
	echo Invalid Entry. Closing script...
	set errorCode=12
	goto :errorMessage
)
exit /b 0

:checkLog
:: Section 2 - Log check
echo:
echo Copying files from %source% to %dest%
echo:
if not exist %logFile% (
	echo Log does not exist. Making log...
	break > %logFile%
	set errorCode=21
	goto :doRobo
)else (
	echo Log exists. Will append to log file: %logFile%
	goto :doRobo
)
exit /b 0
:: End Section 2

:doRobo
:: Attempt to copy data
:: Start Log Header
echo *************** >> %logFile%
break >> %logFile%
whoami >> %logFile%
break >> %logFile%
hostname >> %logFile%
break >> %logFile%
date /t >> %logFile%
break >> %logFile%
time /t >> %logFile%
break >> %logFile%
echo *************** >> %logFile%
:: End Log Header

:: robocopy the files from source to destination and outputing result to prompt as well as logging data to log file
robocopy %source% %dest% /E /COPYALL /MT[%threads%-1] /DCOPY:DATE /R:5 /W:5 /V /ETA /TEE /LOG+:%logFile%
break >> %logFile%
exit /b 0
:: End Copy data 

:errorMessage
:: Start Error handling catch and output code with reference
echo:
echo ==========================
echo Exiting with error code %errorCode%
echo Reference README.txt
echo ==========================
pause
exit /b 0
:: End Error handling

endlocal
