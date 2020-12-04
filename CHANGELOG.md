# April 16, 2019 - v.0.19.1

- Added gtest for test coverage.
- Fixed error messages: now file, line number and error always are in the 
    same lines (Great for vim make!)
- New support for macOS.

# March 13, 2019

Replaced WAV writing code with new working version.


# February 24, 2019

Completed source code translation to English.


# February 20, 2019

Started translating comments and variable/constant/function names to English.


# September 3, 2016

Fixed not working IF clause bug when using MegaROM.


# December 19, 2013

asMSX patched for working with additional files (thanks to utopian.rgba and samsaga2).


v.0.01a: [10/09/2000] First public version
	v.0.01b: [03/05/2001] Bugfixes. Added PRINTFIX, FIXMUL, FIXDIV
	v.0.10 : [19/08/2004] Overall enhance. Opcodes 100% checked
	v.0.11 : [31/12/2004] IX, IY do accept negative or null offsets
	v.0.12 : [11/09/2005] Recovery version
		Added REPT/ENDR, variables/constants, RANDOM, DEBUG blueMSX,
		BREAKPOINT blueMSX, PHASE/DEPHASE, $ symbol
	v.0.12e: [07/10/2006]
		Additional parameters for INCBIN "file" [SKIP num] [SIZE num]
		Second page locating macro (32KB ROMs / megaROMs)
		Added experimental support for MegaROMs:
			* MEGAROM [mapper] - define mapper type
			* SUBPAGE [n] AT [address] - define page
			* SELECT [n] AT [address] - set page
	v.0.12f: [16/11/2006]
		Several binary operators fixed
		Conditional assembly
	v.0.12f1:[17/11/2006]
		Nested conditional assembly and other conditions
	v.0.12g:[18/03/2007]
		PHASE/DEPHASE bug fixed
		Initial CAS format support
		WAV output added
		Enhanced conditional assembly: IFDEF
	v.0.14: [UNRELEASED]
		First working Linux version
		Somewhat improved stability
	v.0.15: [UNRELEASED]
		ADD IX,HL and ADD IY,HL operations removed
		Label vs Macro collisions solved
		Overall improvement in pointer stability
		INCBIN now can SKIP and SIZE upto 32-bit 
	v.0.16: [CANDIDATE]
		First version fully developed in Linux
		Fixed bug affecting filename extensions
		Removed the weird IM 0/1 - apparently it is just a plain undocumented IM 0 opcode
		FILENAME directive to set assembler output filenames
		ZILOG directive for using Zilog style indirections and official syntax
		ROM/MEGAROM now have a standard 16 byte header
		Fixed a really annoying bug regarding $DB data read as pseudo DB
		SINCLAIR directive included to support TAP file generation (ouch!) --> STILL TO BE TESTED 
		Pending:
			- Adjust BIOS for SINCLAIR model?
			- DISK support
			- R800/Z80/8080/Gameboy support
			- Sinclair ZX Spectrum TAP/TZX file format supported
			
	[Post-Rosby versions]
	v.0.17: [19/12/2013]
		[FIX] Issue 1: Crash on Linux when including additional .asm files (by theNestruo)
		[FIX] Issue 5: Non-zero exit code on errors (by theNestruo)
	v.0.18: [01/02/2017]
		Fixed issue with .megaflashrom and the defines.
	 
	v.0.18.1: [11/02/2017]
		Fixed multiple compilation warnings by specifying function parameters and return type explicitly
		Fixed a problem with cassette file name generation due to uninitialized variable 'fname_bin'
	v.0.18.2: [25/05/2017]
		Added -z flag. This flag allows using standard Zilog syntax without setting .ZILOG on the code.
		Now local labels can be also set using .Local_Label along the previous @@Local_Label.
		Now .instruction are correctly parsed. For instance, before it was allowed to set "azilog", "bzilog"
		instead of only allowing ".zilog" or "zilog".
	v.0.18.3: [10/06/2017]
		Fixed induced bug of February 5th when using INCLUDE. Parser 1 p1_tmpstr wasn't using malloc memory. Instead it uses
		strtok allocated memory. This is never deleted, we must check this in the future to prevent memory leaks.
	v.0.18.4: [18/06/2017]
		Unterminated string hotfix. Find a better way to solve it. Probably a more flex-like fix.
	v.0.19.0: [15/03/2019]
		Completed source code translation to English.
		Replaced WAV writing code with new working version.
	v.0.19.1: [16/04/2019]
        Added gtest for test coverage.
        Fixed error messages: now file, line number and error always are in the 
            same lines (Great for vim make!)
        New support for macOS.
	v.0.19.2: [15/06/2020]
        - Corrected wrally test 
        - Source code lines now can have up to 1024 bytes of length, instead of
          256. This is useful for long DBs (LocoMJ) instead of splitting them
          using several DB instructions.
    v.0.19.3: [01/11/2020]
        - Segmentation faults due to big strings or missing quotes are now
          catched with safe_strcat. Thanks @jamque for reporting :).
        - Modularized error and warning reporting functions.
        - Added CI to the repo (Thanks @duhow!)
        - Default verbose level set to 1. New -s (silent) flag added.
