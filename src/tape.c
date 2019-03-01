/* Tape routines for asMSX */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void write_tape(const int flags, const char *fname_no_ext, const char *fname_int, int type,
	int start_address, int end_address, int run_address, const char *memory)
{
	char fname[_MAX_PATH + 1];

	strcpy(fname, fname_no_ext);
	strcat(fname, ".cas");
	printf("cas file %s\n", fname);

	strcpy(fname, fname_no_ext);
	strcat(fname, ".wav");
	printf("wav file %s\n", fname);
}


// code moved from dura.y

//void write_cas()
//{
//	FILE *f;
//	int i;
//	int cas[8] = {
//	  0x1F, 0xA6, 0xDE, 0xBA, 0xCC, 0x13, 0x7D, 0x74
//	};
//
//	if ((type == MEGAROM) || ((type == ROM) && (start_address < 0x8000)))
//	{
//		warning_message(0);
//		return;
//	}
//
//	fname_bin[strlen(fname_bin) - 3] = 0;
//	fname_bin = strcat(fname_bin, "cas");
//
//	f = fopen(fname_bin, "wb");
//
//	for (i = 0; i < 8; i++)
//		fputc(cas[i], f);
//
//	if ((type == BASIC) || (type == ROM))
//	{
//		for (i = 0; i < 10; i++)
//			fputc(0xd0, f);
//		{
//			size_t t;
//			if (strlen(fname_int) < 6)
//				for (t = strlen(fname_int); t < 6; t++)
//					fname_int[t] = 32;	/* pad with space */
//		}
//
//		for (i = 0; i < 6; i++)
//			fputc(fname_int[i], f);
//
//		for (i = 0; i < 8; i++)
//			fputc(cas[i], f);
//
//		putc(start_address & 0xff, f);
//		putc((start_address >> 8) & 0xff, f);
//		putc(end_address & 0xff, f);
//		putc((end_address >> 8) & 0xff, f);
//		putc(run_address & 0xff, f);
//		putc((run_address >> 8) & 0xff, f);
//	}
//
//	for (i = start_address; i <= end_address; i++)
//		putc(memory[i], f);
//
//	fclose(f);
//	printf("Cassette file %s saved\n", fname_bin);
//}
//
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
//		if (strlen(fname_int) < 6)
//		{
//			size_t t;
//			for (t = strlen(fname_int); t < 6; t++)
//				fname_int[t] = 32; /* 32 is space character */
//		}
//
//		for (i = 0; i < 6; i++)
//			wav_write_byte(fname_int[i]);
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
//			wav_write_byte(memory[i]);
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
//			wav_write_byte(memory[i]);
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
