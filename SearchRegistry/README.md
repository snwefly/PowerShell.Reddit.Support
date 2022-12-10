# Search the Registry

This is in response to [/u/mudderfudden](https://www.reddit.com/user/mudderfudden/) who asked in this [post](https://www.reddit.com/r/PowerShell/comments/zgbqt4/how_can_i_search_entire_registry_for_a_key_and/)how he could locate a specific string in the registry (key name, value name or data). Moreover, he wants to search in multiple hives at once.

## Search-Registry function

This function is based on ```Get-ChildItems``` to list registry keys and depending on where the user looks, will compare using regex for
- Key Name
- Value Name (the id of the value)
- Data

It returns a list of objects with following properties: Registry Key Path, Reason, matched String.

## Usage Example

### Basis 

This will search in "HKLM:\SYSTEM\CurrentControlSet\Services" for the string "svchost". Since no other arguments were specified, we look for the  searched string in every key names, value names and value data.

```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "svchost"
```

The returned list contains strings found in 3 categories, if we want to get a subset of those results, we can specify where to search like this:

The same command but with ```-KeyName``` will only return the entries where the key name match "svchost"

```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "svchost" -KeyName
```

The same command but with ```-ValueData``` will only return the entries where the value data match "svchost"

```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "svchost" -ValueData
```

### REGEX

Since search uses the ```-match``` operator, it does a regex matching. ***So all RegexEx operator applies***

#### Special Characters

Here the ```^``` and the ```$``` characters are used to specify the start and end of the string so that we only search for data containing "Core"

```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "^Core$" -ValueData
```

#### Multiple Words

Let's search the same path for two (2) value names, hence searching 2 words. Like 'Start' and 'Type'. 
The Regex expression is "(Start)|(Type)" or plain "Start|Type"


```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "Start|Type" -Valuename

	Key                                                                                            Reason    String
	---                                                                                            ------    ------
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vpcivsp                                   ValueName Start
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vsmraid                                   ValueName Start
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSS                                       ValueName Type
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSStandardCollectorService150             ValueName ServiceSidType
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\gupdate                                   ValueName DelayedAutostart	
```

Oups, we got ```ServiceSidType``` and ```DelayedAutostart``` and were not looking for those. Use Regex to specify start ant end of string then:


```
    Search-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services" -SearchRegex "^Start$|^Type$" -Valuename

	Key                                                                                            Reason    String
	---                                                                                            ------    ------
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vpcivsp                                   ValueName Start
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\vsmraid                                   ValueName Start
	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VSS                                       ValueName Type

```

***MUCH BETTER***


### Registry Hives

Those are the registry hives that are searchable. 
- HKEY_LOCAL_MACHINE
- HKEY_CURRENT_USER
- HKEY_CLASSES_ROOT
- HKEY_CURRENT_CONFIG
- HKEY_USERS
- HKEY_PERFORMANCE_DATA

But the ones used by a regular users are only those 3:

- HKEY_LOCAL_MACHINE
- HKEY_CURRENT_USER
- HKEY_CLASSES_ROOT

#### NOT RECOMMENDED - search all hives

If you want to search ***ALL HIVES*** you can use this path: 

```
    $RootRegistryPath = "Registry::\"

    Search-Registry -Path $RootRegistryPath -SearchRegex "searchstring" -Recurse
```

Since a lot on values you dont use may be returned, __I dont recommend it.__

Search multiple Hives like so:


```
    $Hives = @('HKCU:\', 'HKLM:\')
    $Results = @()
    ForEach($hive in $Hives){
    	Search-Registry -Path $hive -SearchRegex "Wavebrowser|Wavsor" -Recurse -SilentErrors
    }
    
```

Or this:

```
    $Hives = @('HKCU:\SOFTWARE', 'HKLM:\SYSTEM\CurrentControlSet\Services')
    $Results = @()
    ForEach($hive in $Hives){
    	Search-Registry -Path $hive -SearchRegex "InfPatchComplete|^Core$" -Recurse -Depth 2 -SilentErrors
    }
    
```

### Access Errors in Registry

Access Errors are handled gracecfully, it will not stop the search.

You will get somethis like this.

```
    Search-Registry -Path $RootRegistryPath -SearchRegex "searchstring" -Recurse

	WARNING: Access Error: HKEY_CURRENT_USER\SOFTWARE\DevelopmentSandbox
	WARNING: Access Error: HKEY_CURRENT_USER\SOFTWARE\DevelopmentTestTest
	WARNING: Total Access Errors: 2

```

### SilentErrors

Silence Access Errors by using ```-SilentErrors```

```
    Search-Registry -Path $RootRegistryPath -SearchRegex "searchstring" -Recurse -SilentErrors
```