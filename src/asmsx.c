/* Tape routines for asMSX */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>

#include "asmsx.h"

#ifndef MKFOURCC
#define MKFOURCC(a, b, c, d) ((uint32_t)(a) | (b) << 8 | (c) << 16 | (d) << 24)
#endif

#pragma pack(push, 1)
struct WavHeader
{
	uint32_t	chunk_id;		/* "RIFF" */
	int32_t		chunk_size;		/* file size - 8: size of riff and riff_chunk_size */
	uint32_t	format;			/* "WAVE" */

	uint32_t	subchunk1_id;	/* "fmt " */
	int32_t		subchunk1_size;	/* 16: size of audio_format, num_channels, sample_rate, byte_rate, block_align and bits_per_sample */
	int16_t		audio_format;	/* 1: PCM */
	int16_t		num_channels;	/* 1 or 2 */
	int32_t		sample_rate;	/* 22050, 44100 or 48000 */
	int32_t		byte_rate;		/* should be num_channels * sample_rate * (bits_per_sample / 8) */
	int16_t		block_align;	/* should be num_channels * (bits_per_sample / 8) */
	int16_t		bits_per_sample;	/* 8 or 16 */

	uint32_t	subchunk2_id;	/* "data" */
	int32_t		subchunk2_size;	/* samples_count * num_channels * (bits_per_sample / 8) */
};
#pragma pack(pop)

struct WavState
{
	int16_t		msx_frequence;
	int32_t		sample_rate;
	uint16_t	num_channels;
	uint16_t	bytes_per_sample;
	uint32_t	samples_count;
};

#define FNAME_MSX_LEN 6

void tape_write_byte(const int b, const FILE *casf, const FILE *wavf, struct WavState *wsp)
{
	if (casf)
	{
		int rc;
		rc = fputc((int)b, (FILE *)casf);
		assert(rc != EOF);
	}

	if (wavf)
	{
		// TODO: write implementation
	}
}

/* Build a valid MSX tape file name from any input string:
     - remove path from file name, if any;
	 - if file name is empty, raise an error, since something is wrong with asMSX itself;
	 - if file name is longer then 6 characters, trim it to first 6;
	 - if file name is shorter then 6 characters, pad it with spaces to 6.
*/
void build_tape_file_name(const char *instr, char *outstr)
{
	char *tmp;
	int i;

	/* point tmp to the beginning of file name itself, skipping the path to it */
	tmp = (char *)instr;
	for (i = 0; i < (int)strlen(instr); i++)
		if ((instr[i] == '/') || (instr[i] == '\\') || (instr[i] == ':'))
			tmp = (char *)instr + i + 1;

	if (strlen(tmp) == 0)
	{
		fprintf(stderr, "ERROR: file name not found in string \"%s\" passed to %s\n", instr, __func__);
		exit(1);
	}

	for (i = 0; i < FNAME_MSX_LEN; i++)
		if (i < (int)strlen(tmp))
			outstr[i] = tmp[i];
		else
			outstr[i] = ' ';
	outstr[FNAME_MSX_LEN] = 0;
}

void write_tape(
	const int cas_flags, const char *fname_no_ext, const char *fname_msx,
	const int rom_type, const int start_address, const int end_address, const int run_address,
	const char *rom_buf
)
{
	const int cas_header[8] = {0x1F, 0xA6, 0xDE, 0xBA, 0xCC, 0x13, 0x7D, 0x74};
	const int cas_header_len = (int)(sizeof(cas_header) / sizeof(cas_header[0]));

	char fname_cas[_MAX_PATH + 1];
	char fname_wav[_MAX_PATH + 1];
	char _fname_msx[FNAME_MSX_LEN + 1];
	FILE *wavf = NULL;
	FILE *casf = NULL;
	int i;

	struct WavState ws =
	{
		1200,	/* msx_frequence	*/
		44100,	/* sample_rate		*/
		1,		/* num_channels		*/
		1,		/* bytes_per_sample	*/
		0		/* samples_count	*/
	};
	
	if (rom_type == MEGAROM)
	{
		fprintf(stderr, "WARNING: cas file generation is not supported for MEGAROM\n");
		return;
	}

	if ((rom_type == ROM) && (start_address < 0x8000))
	{
		fprintf(stderr, "WARNING: cas file generation is not supported for ROM that start below address 0x8000. Current start address is %#06x\n", start_address);
		return;
	}

	build_tape_file_name(fname_msx, _fname_msx);

#if _DEBUG
	printf("call function %s(%d, \"%s\", \"%s\", %d, %#06x, %#06x, %#06x, %p)\n",
		__func__, cas_flags, fname_no_ext, fname_msx,
		rom_type, start_address, end_address, run_address, (void *)rom_buf);
	printf("sanitized tape file name is \"%s\"\n", _fname_msx);
#endif

	if (cas_flags & 1)		/* check if bit 0 is set, i.e. need to generate cas */
	{
		strcpy(fname_cas, fname_no_ext);
		strcat(fname_cas, ".cas");
		printf("cas file %s\n", fname_cas);
		casf = fopen(fname_cas, "wb");
		if (!casf)
		{
			fprintf(stderr, "ERROR: can't create file %s in %s\n", fname_cas, __func__);
			exit(1);
		}
	}

	if (cas_flags & 2)		/* check if bit 1 is set, i.e. need to generate wav */
	{
		int rc;
		struct WavHeader wh;

		strcpy(fname_wav, fname_no_ext);
		strcat(fname_wav, ".wav");
		printf("wav file %s\n", fname_wav);
		wavf = fopen(fname_wav, "wb");
		if (!wavf)
		{
			fprintf(stderr, "ERROR: can't create file %s in %s\n", fname_wav, __func__);
			exit(1);
		}

		/* build the wav file header */
		assert(sizeof(wh) == 44);
		wh.chunk_id = MKFOURCC('R', 'I', 'F', 'F');		/* "RIFF" */
		wh.chunk_size = -1;								/* file size - 8 (8 == sizeof(chunk_id) + sizeof(chunk_size)) */
		wh.format = MKFOURCC('W', 'A', 'V', 'E');		/* "WAVE" */
		wh.subchunk1_id = MKFOURCC('f', 'm', 't', ' ');	/* "fmt " */
		wh.subchunk1_size = sizeof(wh.audio_format) + sizeof(wh.num_channels) + sizeof(wh.sample_rate) +
			sizeof(wh.byte_rate) + sizeof(wh.block_align) + sizeof(wh.bits_per_sample);
		assert(wh.subchunk1_size == 16);				/* this should always be 16 */
		wh.audio_format = 1;							/* 1: PCM */
		wh.num_channels = ws.num_channels;				/* 1 or 2 */
		wh.sample_rate = ws.sample_rate;				/* 22050, 44100 or 48000 */
		wh.bits_per_sample = 8 * ws.bytes_per_sample;	/* 8 or 16 */
		wh.byte_rate = wh.num_channels * wh.sample_rate * (wh.bits_per_sample / 8);
		wh.block_align = wh.num_channels * (wh.bits_per_sample / 8);
		wh.subchunk2_id = MKFOURCC('d', 'a', 't', 'a');	/* "data" */
		wh.subchunk2_size = -1;	/* samples_count * num_channels * (bits_per_sample / 8) */

		/* write WAV header  */
		rc = fwrite(&wh, sizeof(struct WavHeader), 1, wavf);
		assert(rc == 1);
	}

	for (i = 0; i < cas_header_len; i++)
		tape_write_byte(cas_header[i], casf, wavf, &ws);

	if ((rom_type == BASIC) || (rom_type == ROM))
	{
		for (i = 0; i < 10; i++)
			tape_write_byte(0xd0, casf, wavf, &ws);

		for (i = 0; i < (int)strlen(_fname_msx); i++)
			tape_write_byte(_fname_msx[i], casf, wavf, &ws);

		for (i = 0; i < cas_header_len; i++)
			tape_write_byte(cas_header[i], casf, wavf, &ws);

		tape_write_byte(start_address & 0xff, casf, wavf, &ws);
		tape_write_byte((start_address >> 8) & 0xff, casf, wavf, &ws);
		tape_write_byte(end_address & 0xff, casf, wavf, &ws);
		tape_write_byte((end_address >> 8) & 0xff, casf, wavf, &ws);
		tape_write_byte(run_address & 0xff, casf, wavf, &ws);
		tape_write_byte((run_address >> 8) & 0xff, casf, wavf, &ws);
	}

	for (i = start_address; i <= end_address; i++)
		tape_write_byte(rom_buf[i], casf, wavf, &ws);

	if (casf)
		fclose(casf);

	if (wavf)
	{
		// TODO: add seek() to start and overwrite header with known values for chunk_size and subchunk2_size
		fclose(wavf);
	}
}


// code moved from dura.y
//void wav_store(int value)
//{
//	fputc(value & 0xff, fwav);
//	fputc((value >> 8) & 0xff, fwav);
//}
//
//void wav_write_one()
//{
//	int l;
//
//	for (l = 0; l < 5 * 2; l++)
//		wav_store(FREQ_LO);
//
//	for (l = 0; l < 5 * 2; l++)
//		wav_store(FREQ_HI);
//
//	for (l = 0; l < 5 * 2; l++)
//		wav_store(FREQ_LO);
//
//	for (l = 0; l < 5 * 2; l++)
//		wav_store(FREQ_HI);
//}
//
//void wav_write_zero()
//{
//	int l;
//
//	for (l = 0; l < 10 * 2; l++)
//		wav_store(FREQ_LO);
//
//	for (l = 0; l < 10 * 2; l++)
//		wav_store(FREQ_HI);
//}
//
//void wav_write_nothing()
//{
//	int l;
//
//	for (l = 0; l < 18 * 2; l++)
//		wav_store(SILENCE);
//}
//
//void wav_write_byte(int m)	/* only used in write_wav() */
//{
//	int l;
//
//	wav_write_zero();
//	for (l = 0; l < 8; l++)
//	{
//		if (m & 1)
//			wav_write_one();
//		else
//			wav_write_zero();
//		m = m >> 1;
//	}
//	wav_write_one();
//	wav_write_one();
//}
//
//void write_wav()	/* This function is broken since public GPLv3 release */
//{
//	int wav_header[44] = {
//	  0x52, 0x49, 0x46, 0x46,
//	  0x44, 0x00, 0x00, 0x00,
//	  0x57, 0x41, 0x56, 0x45,
//	  0x66, 0x6D, 0x74, 0x20,
//	  0x10, 0x00, 0x00, 0x00,
//	  0x01, 0x00, 0x02, 0x00,
//	  0x44, 0xAC, 0x00, 0x00,
//	  0x10, 0xB1, 0x02, 0x00,
//	  0x04, 0x00, 0x10, 0x00,
//	  0x64, 0x61, 0x74, 0x61,
//	  0x20, 0x00, 0x00, 0x00
//	};
//	int wav_size, i;
//
//	if ((type == MEGAROM) || ((type == ROM) && (start_address < 0x8000)))
//	{
//		warning_message(0);
//		return;
//	}
//
//	fname_bin[strlen(fname_bin) - 3] = 0;
//	fname_bin = strcat(fname_bin, "wav");
//
//	fwav = fopen(fname_bin, "wb");
//
//	if ((type == BASIC) || (type == ROM))
//	{
//		wav_size = (3968 * 2 + 1500 * 2 + 11 * (10 + 6 + 6 + end_address - start_address + 1)) * 40;
//		wav_size = wav_size << 1;
//
//		wav_header[4] = (wav_size + 36) & 0xff;
//		wav_header[5] = ((wav_size + 36) >> 8) & 0xff;
//		wav_header[6] = ((wav_size + 36) >> 16) & 0xff;
//		wav_header[7] = ((wav_size + 36) >> 24) & 0xff;
//		wav_header[40] = wav_size & 0xff;
//		wav_header[41] = (wav_size >> 8) & 0xff;
//		wav_header[42] = (wav_size >> 16) & 0xff;
//		wav_header[43] = (wav_size >> 24) & 0xff;
//
//		/* Write WAV header */
//		for (i = 0; i < 44; i++)
//			fputc(wav_header[i], fwav);
//
//		/* Write long header */
//		for (i = 0; i < 3968; i++)
//			wav_write_one();
//
//		/* Write file identifier */
//		for (i = 0; i < 10; i++)
//			wav_write_byte(0xd0);
//
//		/* Write MSX name */
//		if (strlen(fname_msx) < 6)
//		{
//			size_t t;
//			for (t = strlen(fname_msx); t < 6; t++)
//				fname_msx[t] = 32; /* 32 is space character */
//		}
//
//		for (i = 0; i < 6; i++)
//			wav_write_byte(fname_msx[i]);
//
//		/* Write blank */
//		for (i = 0; i < 1500; i++)
//			wav_write_nothing();
//
//		/* Write short header */
//		for (i = 0; i < 3968; i++)
//			wav_write_one();
//
//		/* Write start, end and run addresses */
//		wav_write_byte(start_address & 0xff);
//		wav_write_byte((start_address >> 8) & 0xff);
//		wav_write_byte(end_address & 0xff);
//		wav_write_byte((end_address >> 8) & 0xff);
//		wav_write_byte(run_address & 0xff);
//		wav_write_byte((run_address >> 8) & 0xff);
//
//		/* Write data */
//		for (i = start_address; i <= end_address; i++)
//			wav_write_byte(rom_buf[i]);
//	}
//	else if (type == Z80)
//	{
//		wav_size = (3968 * 1 + 1500 * 1 + 11 * (end_address - start_address + 1)) * 36;
//		wav_size = wav_size << 1;
//
//		wav_header[4] = (wav_size + 36) & 0xff;
//		wav_header[5] = ((wav_size + 36) >> 8) & 0xff;
//		wav_header[6] = ((wav_size + 36) >> 16) & 0xff;
//		wav_header[7] = ((wav_size + 36) >> 24) & 0xff;
//		wav_header[40] = wav_size & 0xff;
//		wav_header[41] = (wav_size >> 8) & 0xff;
//		wav_header[42] = (wav_size >> 16) & 0xff;
//		wav_header[43] = (wav_size >> 24) & 0xff;
//
//		/* Write WAV header */
//		for (i = 0; i < 44; i++)
//			fputc(wav_header[i], fwav);
//
//		/* Write long header */
//		for (i = 0; i < 3968; i++)
//			wav_write_one();
//
//		/* Write data */
//		for (i = start_address; i <= end_address; i++)
//			wav_write_byte(rom_buf[i]);
//	}
//	else
//		wav_size = 0;
//
//	/* Write blank */
//	for (i = 0; i < 1500; i++)
//		wav_write_nothing();
//
//	/* Close file */
//	fclose(fwav);
//
//	printf("Audio file %s saved [%2.2f sec]\n", fname_bin, (float)wav_size / 176400);
//}
