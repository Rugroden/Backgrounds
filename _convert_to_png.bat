@ECHO off

:: Confirm IMage Magick is installed.
WHERE magick >nul 2>nul
IF NOT %ERRORLEVEL% == 0 (
  @ECHO on
  ECHO Unable to run conversion. Install Image Magick an run again. https://imagemagick.org/
  goto :eof
)

:: Run the conversion on the root directory.
call :convertAndRemove
:: Then run it on the subdirectories, except the .git directory.
FOR /F "tokens=*" %%F IN ('DIR /AD /B') DO (
  IF NOT %%F == .git (
    cd %%F
    call :convertAndRemove
    cd ..
  )
)
goto :eof

:convertAndRemove
:: Convert the .jpg files and remove them.
magick mogrify -format png *.jpg >nul 2>nul

IF %ERRORLEVEL% == 0 (
  @ECHO on
  ECHO All .jpg  files converted in %cd%
  @ECHO off
) ELSE (
  @ECHO on
  ECHO No  .jpg  files to convert in %cd%
  @ECHO off
)
DEL *.jpg >nul 2>nul

:: Convert the .jpeg files and remove them.
magick mogrify -format png *.jpeg >nul 2>nul
IF %ERRORLEVEL% == 0 (
  @ECHO on
  ECHO All .jpeg files converted in %cd%
  @ECHO off
) ELSE (
  @ECHO on
  ECHO No  .jpeg files to convert in %cd%
  @ECHO off
)

DEL *.jpeg >nul 2>nul

goto :eof