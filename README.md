# asMSX

![asmsx](doc/asmsx.png)

[CHANGELOG](CHANGELOG.md)

asMSX is a Z80 cross-assembler for MSX, originally developed by Eduardo "pitpan" A. Robsy Petrus and now mantained by the asMSX team.
This project is based on [GPLv3 code release by Lucas "cjv99"](https://code.google.com/archive/p/asmsx-license-gpl/).
MRC wiki has an entry for [asMSX](https://www.msx.org/wiki/asMSX).

Please read [asMSX manual](doc/asmsx.md) to learn more.

**DOWNLOAD:** You can find latest release [here](https://github.com/Fubukimaru/asMSX/releases/).

If you'd like to contribute to this project, please take a look at our [coding style guide](doc/coding-style.md).

Please help us improve test coverage for the code. Read our [testing guide](doc/testing.md) and contribure!

## asMSX team
The asMSX team is a undefined collective that has worked on this program or has helped with it. asMSX wont be as it is if it wasn't for the colaboration of:

- Eduardo Robsy
- @cjv99 (Thanks for buying and sharing it!)
- @ibannieto
- @theNestruo
- @Fubukimaru
- @oboroc
- @jamque
- @mvac7
- @duhow
- @LocoMJ
- @libertium
- vim
- The game

# List of related projects

Contact us to include yours!

## Projects done using asMSX

- (TPMSX-Engine)[https://github.com/jamque/TPMSX-Engine]: The Pets Mode Engine. An engine born from TPM projects like Bitlogic.
- (MSX_ngine)[https://github.com/knightfox75/msx_ngine]: A set of MSX libraries by KnightFox75.


## Projects that may be interesting for you if you use asMSX!

- (Santiago Ontañon's mdlz80optimizer)[https://github.com/santiontanon/mdlz80optimizer]: A great Z80 code optimizer compatible with asMSX syntax.


# Original Spanish README

Estructura de carpetas

- BIN: versiones compiladas de asMSX para Windows y Linux (32 bits).
- SRC: código fuente del asMSX
- MAN: manual en castellano del asMSX
- REF: dos documentos de referencia, incluidos para tu consulta
- CODE: ejemplo de código fuente de dos juegos sencillos

Instrucciones para compilar

- Necesitas tener instalado GCC, Flex, Bison
- No está de más tener UPX, aunque no es imprescindible
- Tienes un MAKEFILE sin extensión, compila asMSX para Linux
- MAKEFILE.WIN (tienes que quitarle la extensión), compila asMSX para Windows

Muchas gracias a pitpan el auténtico y genuino creador del compilador asmsx.
cjv99 un humilde servidor que libera asmsx abierta para su distribución de forma gratuita.
