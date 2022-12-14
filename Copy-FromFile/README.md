# Copy-FromFile function

This is in response to [/u/happy_Bunny1](https://www.reddit.com/user/happy_Bunny1/) who asked in this [post](https://www.reddit.com/r/PowerShell/comments/zlg7uh/copy_files_from_a_text_list_and_preserve_folder/)how he could copy files listed in a text file to a specific folder, while preserving folder structure

##  Copy-FromFile


## HOW TO TEST

```
    Copy-FromFile -Destination $Destination -File $File -Overwrite -SilentErrors
```

[Copy-FromFile.ps1](https://github.com/arsscriptum/PowerShell.Reddit.Support/blob/main/Copy-FromFile/Copy-FromFile.ps1)