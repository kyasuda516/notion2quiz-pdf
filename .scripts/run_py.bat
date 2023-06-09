@REM Copyright (c) 2023 Kanta Yasuda (GitHub: @kyasuda516)
@REM This software is released under the MIT License, see LICENSE.

@REM $ this_bat_path py_path
call %userprofile%\anaconda3\Scripts\activate.bat notion2quiz-pdf-env
python %1
echo --------------------------------------------------------------------
echo The program execution completed.
echo Once you press any key, this window will be closed.
echo If you not, in 60 seconds this window is automatically being closed.
timeout /t 60
conda deactivate
