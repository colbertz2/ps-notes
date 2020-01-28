# Testing the Scope of .NET Namespace Declarations

## Background
At work, our in-house module exports a number of functions we've written to perform common tasks. It's organized like the example module shown here: A module manifest and module script are in the root directory. Each exported function gets its own file in the `src` directory, and the module script sources each of those files when the module is imported.

## The Question
I recently wrote a new function for the module that uses some .NET classes for fancy GUI stuff and user prompts. I also decided to use some proper Active Directory exception classes when something goes wrong. 

Using these types can sometimes be a pain, because their namespaces are so long. For example, the AD exception type I wanted to throw comes out to be `System.DirectoryServices.ActiveDirectory.ActiveDirectoryObjectExistsException`. Being the good little programmer I am, I try to limit the length of each line in my scripts--and I've just used up 2/3 of my available line length on this exception type.

A way around this is to declare namespaces at the start of the script. This tells PowerShell (or .NET?) that you're going to be using classes/objects/types from a certain namespace, and significantly shortens things up in the code later on. [about_Using](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-7)

The documentation shows that these namespace declarations must be the first thing in a script, which means I can't wrap them up inside my function. This brings the question: What is the scope of these namespace declarations in the context of my module? Or, if I use a namespace declaration in one script, will another script within the module also use that namespace?

## The Test
In our module at work, I ended up writing 3 test scripts to test the namespace in 3 different file locations relative to the script that declares the namespace. For this simplified example, I only show one (but the point still stands).

This example module sources two scripts from the `src` directory: `Get-Namespace.ps1` and `Test-Namespace.ps1`.

The `Get-Namespace.ps1` script declares two .NET namespaces (the aforementioned `System.DirectoryServices.ActiveDirectory`, and `System.Management.Automation.Host`), and defines the function `Get-Namespace`. This function doesn't do anything with the declared namespaces, it's just there so we can say the script does something.

`Test-Namespace.ps1` defines the function `Test-Namespace`, which attempts to use types from each of the .NET namespaces declared in `Get-Namespace.ps1`. In an ideal world the namespace declarations are scoped to the script they were used in, `Test-Namespace` will be unable to find the types we are calling, and will print a couple of failed tests to the console.

If, however, the namespace declarations are not scoped the way I want, `Test-Namespace` will successfully create objects from those two .NET namespaces, and return passed tests.

## The Results
The unfortunate truth is that these namespace declarations are not scoped the way I want them to be. Thanks, PowerShell.

```
PS C:\Users\colbertz\Developer\ps-notes\doc\dot-net-namespace> Import-Module .\dot-net-namespace.psd1
PS C:\Users\colbertz\Developer\ps-notes\doc\dot-net-namespace> Get-Namespace
0
PS C:\Users\colbertz\Developer\ps-notes\doc\dot-net-namespace> Test-Namespace
✓ Namespace found: System.Management.Automation.Host
✓ Found namespace System.DirectoryServices.ActiveDirectory
```

This demonstrates that a namespace declaration made in one script (even when it's being sourced/exported by a module), also affects neighboring scripts. In my case this likely won't ruin any of the other functions exported by our module at work, but there is the possibility of a type collision if we happened to define an object type or class with the same name as a .NET type, then declare that type's namespace in another script.

## Conclusion
If you're worried about conflicting type names, avoid `using namespace` in your module scripts. Suck it up, and write really long lines to accommodate the .NET namespaces you need.

Or, if you want scripts that will be compatible with PowerShell 6 and later, perhaps avoid using .NET types altogether?