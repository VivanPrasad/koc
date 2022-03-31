# Building & Publishing
## Building
To build KoC, ensure that you have Embed PCK disabled as it can trigger antiviruses until GoDot releases a proper fix for it. 
Make sure that the build's version field matches a `MAJOR.MINOR.PATCH.COMMIT` format, for example `1.11.1.34` but the actual `EXE` named `KoC_Alpha_` with the
`MAJOR.MINOR.PATCH` format (example: `KoC_Alpha_1.11.0`). 
You want to build two versions,a 32-bit version and a 64-bit version.

## Publishing
To publish (aka. release) KoC, you want a `ZIP` file with the 32-bit and 64-bit `EXE` files inside, such as the following for Windows releases:
```
- windows.zip
   - KoC_Alpha_x.x.x_64bit.exe
   - KoC_Alpha_x.x.x_32bit.exe
```
