#
# commands
#

ASM=../../src/asmsx
# ASM=\bin\asMSX\src\asmsx
CCOMPILER=gcc
COPY=cmd /c copy
DEBUGGER=/MSX/blueMSX/blueMSX.exe
EMULATOR=cmd /c start
MOVE=cmd /c move
#PACK=pletter
#PCX2MSX=pcx2msx+
#PCX2SPR=pcx2spr
#PCX2SPRPLUS=pcx2spr+
#REMOVE=cmd /c del
#TMX2BIN=tmx2bin
#TMX2MAP=tools/tmx2map/tmx2map
#TYPE=cmd /c type

#
# file lists
#

SRCS=\
	src/rally.asm \
	src/rally_rom_page0.asm \
	src/rally_rom_code.asm \
	src/rally_rom_data.asm \
	src/rally_ram.asm

GFXS=\
	gfx/charset_bw_title.pcx.chr.plet5 \
	gfx/charset_bw_font.pcx.chr.plet5 \
	gfx/charset_bw_smallfont.pcx.chr \
	gfx/charset_color_rallies.pcx.chr.plet5 \
	gfx/charset_color_rallies.pcx.clr.plet5 \
	gfx/charset_color_ingame.pcx.chr.plet5 \
	gfx/charset_color_ingame.pcx.clr.plet5 \
	gfx/charset_cutscene_attractmode.pcx.chr.plet5 \
	gfx/charset_cutscene_attractmode.pcx.clr.plet5 \
	gfx/charset_cutscene_shared.pcx.chr.plet5 \
	gfx/charset_cutscene_shared.pcx.clr.plet5 \
	gfx/charset_cutscene_ending.pcx.chr.plet5 \
	gfx/charset_cutscene_ending.pcx.clr.plet5

GFXS_CLEANALL=\
	gfx/charset_bw_title.pcx.chr \
	gfx/charset_bw_font.pcx.chr \
	gfx/charset_color_rallies.pcx.chr \
	gfx/charset_color_ingame.pcx.chr \
	gfx/charset_cutscene_attractmode.pcx.chr \
	gfx/charset_cutscene_shared.pcx.chr \
	gfx/charset_cutscene_ending.pcx.chr \
	gfx/charset_bw_title.pcx.clr \
	gfx/charset_bw_font.pcx.clr \
	gfx/charset_bw_smallfont.pcx.clr \
	gfx/charset_color_rallies.pcx.clr \
	gfx/charset_color_ingame.pcx.clr \
	gfx/charset_cutscene_attractmode.pcx.clr \
	gfx/charset_cutscene_shared.pcx.clr \
	gfx/charset_cutscene_ending.pcx.clr

SPRS=\
	spr/spr_car.pcx.spr.asm \
	spr/spr_car.pcx.spat.asm \
	spr/spr_numbers.pcx.spr \
	spr/spr_default.pcx.spr.plet5 \
	spr/spr_others_start.pcx.spr.plet5 \
	spr/spr_others_end.pcx.spr.plet5 \
	spr/spr_events.pcx.spr.plet5

SPRS_CLEANALL=\
	spr/spr_default.pcx.spr \
	spr/spr_others_start.pcx.spr \
	spr/spr_others_end.pcx.spr \
	spr/spr_events.pcx.spr

DATAS=\
	data/tileset.tmx.bin \
	gfx/charset_cutscene_attractmode.pcx.nam.plet5 \
	gfx/charset_cutscene_ending.pcx.nam.plet5 \
	gfx/charset_cutscene_shared.pcx.nam.plet5 \
	data/map_perinaldo.tmx.bin.plet5 \
	data/map_totip.tmx.bin.plet5 \
	data/map_moulinon.tmx.bin.plet5 \
	data/map_sisteron.tmx.bin.plet5 \
	data/map_coldeturini.tmx.bin.plet5 \
	data/map_myhipaa.tmx.bin.plet5 \
	data/map_konivouri.tmx.bin.plet5 \
	data/map_laajavuori.tmx.bin.plet5 \
	data/map_wip.tmx.bin.plet5

DATAS_CLEANALL=\
	gfx/charset_cutscene_attractmode.pcx.nam \
	gfx/charset_cutscene_shared.pcx.nam \
	gfx/charset_cutscene_ending.pcx.nam \
	data/map_perinaldo.tmx.bin \
	data/map_totip.tmx.bin \
	data/map_moulinon.tmx.bin \
	data/map_sisteron.tmx.bin \
	data/map_coldeturini.tmx.bin \
	data/map_myhipaa.tmx.bin \
	data/map_konivouri.tmx.bin \
	data/map_laajavuori.tmx.bin \
	data/map_wip.tmx.bin
# gfx\charset_cutscene_rallyover.pcx.nam \

TOOLS=\
	$(TMX2MAP).exe

#
# phony targets
#

# default target:
default: rally.rom

gfx: $(GFXS)

spr: $(SPRS)

data: $(DATAS)

# main targets
run: rally.rom
	$(EMULATOR) $<

debug: rally.rom
	$(DEBUGGER) $<

clean:
	$(REMOVE) ~tmppre.? src/rally.txt src/rally.sym

cleangfx:
	$(REMOVE) $(GFXS) $(GFXS_CLEANALL)

cleanspr:
	$(REMOVE) $(SPRS) $(SPRS_CLEANALL)

cleandata:
	$(REMOVE) $(DATAS) $(DATAS_CLEANALL)

cleanall: clean cleangfx cleanspr cleandata

# secondary targets
.secondary: $(GFXS_CLEANALL) $(SPRS_CLEANALL) $(DATAS_CLEANALL)

#
# GFXs
#

rally.rom: $(SRCS) $(GFXS) $(SPRS) $(DATAS)
	#$(REMOVE) src/rally.txt
	$(ASM) $<
	#$(TYPE) src/rally.txt
	#$(MOVE) src\rally.z80 $@

#
# GFXs
#

#gfx\charset_%.pcx.chr.plet5: gfx\charset_%.pcx.chr
#	$(PACK) $<
#
#gfx\charset_%.pcx.clr.plet5: gfx\charset_%.pcx.clr
#	$(PACK) $<
#
#gfx\charset_%.pcx.nam.plet5: gfx\charset_%.pcx.nam
#	$(PACK) $<
#
#gfx\charset_bw_%.pcx.chr: gfx\charset_bw_%.pcx
#	$(PCX2MSX) -hl $<
#
#gfx\charset_color_%.pcx.chr gfx\charset_color_%.pcx.clr: gfx\charset_color_%.pcx
#	$(PCX2MSX) $<
#
#gfx\charset_cutscene_%.pcx.chr gfx\charset_cutscene_%.pcx.clr gfx\charset_cutscene_%.pcx.nam: gfx\charset_cutscene_%.pcx
#	$(PCX2MSX) -n0 -bb20 -rr $<
#
#
# SPRs
#

#spr\spr_%.pcx.spr.plet5: spr\spr_%.pcx.spr
#	$(PACK) $<
#
#spr\spr_car.pcx.spr.asm spr\spr_car.pcx.spat.asm: spr\spr_car.pcx
#	$(PCX2SPRPLUS) -w32 -h32 $< -v -vv
#
#spr\spr_numbers.pcx.spr: spr\spr_numbers.pcx
#	$(PCX2SPR) -h $<
#
#spr\spr_default.pcx.spr: spr\spr_default.pcx
#	$(PCX2SPR) $<
#
#spr\spr_others_start.pcx.spr: spr\spr_others_start.pcx
#	$(PCX2SPR) $<
#
#spr\spr_others_end.pcx.spr: spr\spr_others_end.pcx
#	$(PCX2SPR) $<
#
#spr\spr_events.pcx.spr: spr\spr_events.pcx
#	$(PCX2SPR) $<

#
# datas
#

# data\tileset.tmx.bin: data\tileset.tmx
# 	$(TMX2BIN) -t8 $< $@
# 
# data\map%.tmx.bin.plet5: data\map%.tmx.bin
# 	$(PACK) $<
# 
# data\map%.tmx.bin: data\map%.tmx $(TMX2MAP).exe
# 	$(TMX2MAP).exe $< $@

#
# tools
#

# tools: $(TOOLS)
# 
# cleantools:
# 	$(REMOVE) $(TOOLS)
# 
# $(TMX2MAP).exe: $(TMX2MAP).c
# 	$(CCOMPILER) -Wall -O3 $< -o $@
