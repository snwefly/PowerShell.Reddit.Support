# Handling Errors in Get-ChildItems

This code shows how to use ```ErrorVariable``` argument to store and handle errors when listing folders with Get-ChildItems.

## Test - Get-TestPaths

Creates 3 paths: 
- one not readable
- one not existant
- one normal

## Test - Test-GciErrorHandling

Actually list the 3 test folders and handles the errors

## HOW TO TEST

```
    .\RunTest.ps1 -Verbose

	[Get-ChilItems Error] -> [C:\Users\gp\AppData\Local\Temp\TestGciErrors\NonExistant]
	ObjectNotFound: (C:\Users\gp\AppData…iErrors\NonExistant:String) [Get-ChildItem], ItemNotFoundException

	[Get-ChilItems Error] -> [C:\Users\gp\AppData\Local\Temp\TestGciErrors\NotReadable]
	PermissionDenied: (C:\Users\gp\AppData…iErrors\NotReadable:String) [Get-ChildItem], UnauthorizedAccessException

	C:\Users\gp\AppData\Local\Temp\TestGciErrors\Normal\child_1
	C:\Users\gp\AppData\Local\Temp\TestGciErrors\Normal\child_2
	C:\Users\gp\AppData\Local\Temp\TestGciErrors\Normal\child_3
```