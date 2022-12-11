# Handling Errors in Get-ChildItems

This code shows how to use ```ErrorVariable``` argument to store and handle errors when listing folders with Get-ChildItems.

## Test - Get-TestPaths

Creates 3 paths: 
- one not readable
- one not existant
- one normal

## Test - Test-GciErrorHandling

Actually list the 3 test folders and handles the errors