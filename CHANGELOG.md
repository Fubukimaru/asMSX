# version 1.0.3: [04/11/2023]

- QuesadaSX Fixes defining labels when they don't have to be excluded by an if

# version 1.0.1: [17/08/2021]


- Implemented the first version of the macro system
- Improved error messaging
- #3  - Added new .BIOSVAR as Bios Variables were missing
- #86 - Build: Add OSX, Linux armhf and upload artifacts , thanks to @duhow!
- #79 - Add gitattributes and edit Github Actions workflow run , thanks to @duhow!
- #78 - Fix Windows build , thanks to @duhow!
- #74 - Update documentation , thanks to @oboroc!
- #73 - Add Github Actions Release Drafter , thanks to @duhow!

# version 1.0.0: [07/12/2020]

- Updated Readme, Changelog and Documentation (Thanks to @jamque Pull request #71 )
- When we use reserved keywords as labels, we state it as `reserved word used  as identifier`. Issue #70 
- MegaROM undefined page message improved.
- We dont' allow `(whatever character)REPT` anymore. Only `REPT` or `.REPT`.
- `PSEUDO_DS` now doesn't check if there is a memory overflow in the first pass. This prevents it to crash in presence of undefined labels and report wrong error message. Issue #62 
- Added `.ZILOG 0` pseudo. Now we can enable and disable zilog standard parsing. Note: this needs more checking between passes. (Thanks to @duhow Pull request #72)
- Improved argument handling (Thanks to @duhow Issue #60)
- Windows tester works again (Thanks to @duhow)
- Makefile improvements (Thanks to @duhow)

# v.1.0 beta: [01/12/2020]

- Finally the NOP bug has been fixed. This is the main reason we go to version 1.0 beta.
- Multiline C-like comments now don't print "/" or "\*"
- Changed strcpy to strncopy for safety and to safe_strcat. This prevents overflows in arrays.
- Debug msgs are redirected to to stderr (--vv)
- Clarified the warning message of bit overflow on values

Special thanks to @jamque for effort producing and testing NOP crashing code!

# v.0.19.3: [01/11/2020]

- Segmentation faults due to big strings or missing quotes are now
    catched with safe_strcat. Thanks @jamque for reporting :).
- Modularized error and warning reporting functions.
- Added CI to the repo (Thanks @duhow!)
- Default verbose level set to 1. New -s (silent) flag added.

# v.0.19.2: [15/06/2020]

- Corrected wrally test 
- Source code lines now can have up to 1024 bytes of length, instead of
    256. This is useful for long DBs (@LocoMJ) instead of splitting them
    using several DB instructions.
 
# v.0.19.1: [16/04/2019]

- Added gtest for test coverage.
- Fixed error messages: now file, line number and error always are in the 
    same lines (Great for vim make!)
- New support for macOS.


# v.0.19.0: [15/03/2019]

- Completed source code translation to English.
- Replaced WAV writing code with new working version.


# v.0.18.4: [18/06/2017]

- Unterminated string hotfix. Find a better way to solve it. Probably a more flex-like fix.


# v.0.18.3: [10/06/2017]

- Fixed induced bug of February 5th when using INCLUDE. Parser 1 p1_tmpstr wasn't using malloc memory. Instead it uses
- strtok allocated memory. This is never deleted, we must check this in the future to prevent memory leaks.


# v.0.18.2: [25/05/2017]

- Added -z flag. This flag allows using standard Zilog syntax without setting .ZILOG on the code.
- Now local labels can be also set using .Local_Label along the previous @@Local_Label.
- Now .instruction are correctly parsed. For instance, before it was allowed to set "azilog", "bzilog"
	instead of only allowing ".zilog" or "zilog".


# v.0.18.1: [11/02/2017]

- Fixed multiple compilation warnings by specifying function parameters and return type explicitly
- Fixed a problem with cassette file name generation due to uninitialized variable 'fname_bin'
    
   
# v.0.18: [01/02/2017]

- Fixed issue with .megaflashrom and the defines.

# v.0.17: [19/12/2013]

- Fixed Crash on Linux when including additional .asm files (by theNestruo)
- Fixed Non-zero exit code on errors (by theNestruo)
 


# Pitpan old versions

## v.0.01a: [10/09/2000]

- First public version

## v.0.01b: [03/05/2001]

- Bugfixes. Added PRINTFIX, FIXMUL, FIXDIV

## v.0.10 : [19/08/2004] 

- Overall enhance. Opcodes 100% checked

## v.0.11 : [31/12/2004] 

- IX, IY do accept negative or null offsets

## v.0.12 : [11/09/2005] Recovery version

- Added REPT/ENDR, variables/constants, RANDOM, DEBUG blueMSX,
- BREAKPOINT blueMSX, PHASE/DEPHASE, $ symbol

## v.0.12e: [07/10/2006]

- Additional parameters for INCBIN "file" [SKIP num] [SIZE num]
- Second page locating macro (32KB ROMs / megaROMs)
- Added experimental support for MegaROMs:
	* MEGAROM [mapper] - define mapper type
	* SUBPAGE [n] AT [address] - define page
	* SELECT [n] AT [address] - set page
    
## v.0.12f: [16/11/2006]

- Several binary operators fixed
- Conditional assembly

## v.0.12f1:[17/11/2006]

- Nested conditional assembly and other conditions

## v.0.12g:[18/03/2007]

- PHASE/DEPHASE bug fixed
- Initial CAS format support
- WAV output added
- Enhanced conditional assembly: IFDEF

## v.0.14: [UNRELEASED]
- First working Linux version
- Somewhat improved stability

## v.0.15: [UNRELEASED]

- ADD IX,HL and ADD IY,HL operations removed
- Label vs Macro collisions solved
- Overall improvement in pointer stability
- INCBIN now can SKIP and SIZE upto 32-bit 

## v.0.16: [CANDIDATE]
- First version fully developed in Linux
- Fixed bug affecting filename extensions
- Removed the weird IM 0/1 - apparently it is just a plain undocumented IM 0 opcode
- FILENAME directive to set assembler output filenames
- ZILOG directive for using Zilog style indirections and official syntax
- ROM/MEGAROM now have a standard 16 byte header
- Fixed a really annoying bug regarding \$DB data read as pseudo DB
- SINCLAIR directive included to support TAP file generation (ouch!) --> STILL TO BE TESTED 
- Pending:
	+ Adjust BIOS for SINCLAIR model?
	+ DISK support
	+ R800/Z80/8080/Gameboy support
	+ Sinclair ZX Spectrum TAP/TZX file format supported
		

