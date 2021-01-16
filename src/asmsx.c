/*
 * Routines for asMSX
 *
 * Wav writting code is based on research in
 * https://github.com/oboroc/msxtape-py
 */

#include "asmsx.h"

char error_buffer[124];

/* Build a valid MSX tape file name from any input string:
        - remove path from file name, if any;
        - if file name is longer then 6 characters, trim it to first 6;
        - if file name is shorter then 6 characters, pad it with spaces to 6;
        - if file name is empty or NULL, return six spaces.
*/
void build_tape_file_name(const char *instr, char *outstr) {
  char *tmp = "";

  /* set tape file name to 6 spaces if provided name is NULL */
  if (instr != NULL) {
    /* point tmp to the beginning of file name itself, skipping the path to it
     */
    tmp = (char *)instr;
    for (int i = 0; i < (int)strlen(instr); i++)
      if ((instr[i] == '/') || (instr[i] == '\\') || (instr[i] == ':'))
        tmp = (char *)instr + i + 1;
  }

  for (int i = 0; i < FNAME_MSX_LEN; i++)
    if ((tmp != NULL) && (i < (int)strlen(tmp)))
      outstr[i] = tmp[i];
    else
      outstr[i] = ' ';
  outstr[FNAME_MSX_LEN] = 0;
}

#ifndef MKFOURCC
#define MKFOURCC(a, b, c, d) ((uint32_t)(a) | (b) << 8 | (c) << 16 | (d) << 24)
#endif

#pragma pack(push, 1)
struct WavHeader {
  uint32_t chunk_id;  /* "RIFF" */
  int32_t chunk_size; /* file size - 8: size of riff and riff_chunk_size */
  uint32_t format;    /* "WAVE" */

  uint32_t subchunk1_id; /* "fmt " */
  int32_t
      subchunk1_size;   /* 16: size of audio_format, num_channels, sample_rate,
                           byte_rate, block_align and bits_per_sample */
  int16_t audio_format; /* 1: PCM */
  int16_t num_channels; /* 1 or 2 */
  int32_t sample_rate;  /* 22050, 44100 or 48000 */
  int32_t byte_rate; /* should be num_channels * sample_rate * (bits_per_sample
                        / 8) */
  int16_t block_align;     /* should be num_channels * (bits_per_sample / 8) */
  int16_t bits_per_sample; /* 8 or 16 */

  uint32_t subchunk2_id; /* "data" */
  int32_t
      subchunk2_size; /* samples_count * num_channels * (bits_per_sample / 8) */
};
#pragma pack(pop)

struct WavState {
  int16_t msx_frequence;
  int32_t sample_rate;
  uint16_t num_channels;
  uint16_t bytes_per_sample;
  uint32_t samples_count;
  int32_t min_vol;
  int32_t max_vol;
};

void wav_sample(const int b, const FILE *wavf, struct WavState *wsp) {
  int rc, i;

  for (i = 0; i < wsp->num_channels; i++) {
    if (wsp->bytes_per_sample == 1) {
      rc = fputc((int)b, (FILE *)wavf);
      assert(rc != EOF);
    } else {
      rc = fputc((int)b & 0xff, (FILE *)wavf);
      assert(rc != EOF);
      rc = fputc(((int)b >> 8) & 0xff, (FILE *)wavf);
      assert(rc != EOF);
    }
  }

  wsp->samples_count += wsp->num_channels * wsp->bytes_per_sample;
}

/*  __
   |  | one full square wave pulse at base MSX frequency
|__|
 */
void wav_bit_0(const FILE *wavf, struct WavState *wsp) {
  double samples_per_pulse;
  uint32_t last_pulse, start_sample, half_sample, end_sample, i;

  samples_per_pulse = (double)wsp->sample_rate / (double)wsp->msx_frequence;
  last_pulse = (uint32_t)round((double)wsp->samples_count / samples_per_pulse);
  start_sample = (uint32_t)round(last_pulse * samples_per_pulse);
  half_sample = (uint32_t)round((last_pulse + 0.5) * samples_per_pulse);
  end_sample = (uint32_t)round((last_pulse + 1) * samples_per_pulse);

  for (i = 0; i < half_sample - start_sample; i++)
    wav_sample(wsp->min_vol, wavf, wsp);
  for (i = 0; i < end_sample - half_sample; i++)
    wav_sample(wsp->max_vol, wavf, wsp);
}

/*  _   _
   | | | | two full square wave pulses at two times the base MSX frequency
 |_| |_|
 */
void wav_bit_1(const FILE *wavf, struct WavState *wsp) {
  double samples_per_pulse;
  uint32_t last_pulse, start_sample, quarter_sample, half_sample,
      three_quarters_sample, end_sample, i;

  samples_per_pulse = (double)wsp->sample_rate / (double)wsp->msx_frequence;
  last_pulse = (uint32_t)round((double)wsp->samples_count / samples_per_pulse);
  start_sample = (uint32_t)round(last_pulse * samples_per_pulse);
  quarter_sample = (uint32_t)round((last_pulse + 0.25) * samples_per_pulse);
  half_sample = (uint32_t)round((last_pulse + 0.5) * samples_per_pulse);
  three_quarters_sample =
      (uint32_t)round((last_pulse + 0.75) * samples_per_pulse);
  end_sample = (uint32_t)round((last_pulse + 1) * samples_per_pulse);

  for (i = 0; i < quarter_sample - start_sample; i++)
    wav_sample(wsp->min_vol, wavf, wsp);
  for (i = 0; i < half_sample - quarter_sample; i++)
    wav_sample(wsp->max_vol, wavf, wsp);
  for (i = 0; i < three_quarters_sample - half_sample; i++)
    wav_sample(wsp->min_vol, wavf, wsp);
  for (i = 0; i < end_sample - three_quarters_sample; i++)
    wav_sample(wsp->max_vol, wavf, wsp);
}

/* A byte on MSX tape is encoded with a start bit 0, 8 bits of the byte and 2
 * stop bits 1 */
void wav_byte(const int b, const FILE *wavf, struct WavState *wsp) {
  int i, a_bit;

  wav_bit_0(wavf, wsp);
  for (i = 0; i < 8; i++) {
    a_bit = (b >> i) & 1;
    if (a_bit == 0)
      wav_bit_0(wavf, wsp);
    else
      wav_bit_1(wavf, wsp);
  }
  wav_bit_1(wavf, wsp);
  wav_bit_1(wavf, wsp);
}

/*
Encode ~1.7 seconds of wsp->msx_frequence * 2 tone.
For tape speed of 1200 bod, we need 4000 pulses.
For tape speed of 2400 bod, we need 8000 pulses.
Conveniently, wav_bit_1() produces a pair of wsp->msx_frequence * 2 tone pulses.
 */
void wav_short_header(const FILE *wavf, struct WavState *wsp) {
  uint32_t i, total_pulse_pairs;
  total_pulse_pairs = (uint32_t)round(wsp->msx_frequence * 4000 / (1200.0 * 2));
  for (i = 0; i < (total_pulse_pairs); i++)
    wav_bit_1(wavf, wsp);
}

/* One long header is equivalent to 4 short headers */
void wav_long_header(const FILE *wavf, struct WavState *wsp) {
  uint32_t i;
  for (i = 0; i < 4; i++)
    wav_short_header(wavf, wsp);
}

void tape_write_byte(const int b, const FILE *casf, const FILE *wavf,
                     struct WavState *wsp) {
  if (casf) {
    int rc;
    rc = fputc((int)b, (FILE *)casf);
    assert(rc != EOF);
  }

  if (wavf)
    wav_byte(b, wavf, wsp);
}

const int cas_header[8] = {0x1F, 0xA6, 0xDE, 0xBA, 0xCC, 0x13, 0x7D, 0x74};
const int cas_header_len = (int)(sizeof(cas_header) / sizeof(cas_header[0]));

void tape_short_header(const FILE *casf, const FILE *wavf,
                       struct WavState *wsp) {
  int i;
  if (casf)
    for (i = 0; i < cas_header_len; i++)
      tape_write_byte(cas_header[i], casf, NULL, wsp);
  if (wavf)
    wav_short_header(wavf, wsp);
}

void tape_long_header(const FILE *casf, const FILE *wavf,
                      struct WavState *wsp) {
  int i;
  if (casf)
    for (i = 0; i < cas_header_len; i++)
      tape_write_byte(cas_header[i], casf, NULL, wsp);
  if (wavf)
    wav_long_header(wavf, wsp);
}

void write_tape(const int cas_flags, const char *fname_no_ext,
                const char *fname_msx, const int rom_type,
                const int start_address, const int end_address,
                const int run_address, const char *rom_buf) {
  char fname_cas[PATH_MAX];
  char fname_wav[PATH_MAX];
  char _fname_msx[FNAME_MSX_LEN + 1];
  FILE *casf = NULL;
  FILE *wavf = NULL;
  int i;
  struct WavHeader wh;

  /*
  If you want to change:
  - msx tape frequency (1200/2400/3600),
  - sample rate (22050/44100/48000),
  - num_channels (1/2 for mono/stereo) or
  - bytes per sample (1 or 2 bytes for 8 or 16 bit samples),
  do it here.
  Later, we may export definition for this struct and have it supplied to
  write_type() from main program. This would allow to specify wav specs in asm
  code WAV directive.
  */
  struct WavState ws = {
      1200,  // msx_frequence
      44100, // sample_rate
      1,     // num_channels
      1,     // bytes_per_sample
      0,     // samples_count
      0,     // min_vol
      0      // max_vol
  };

  /* calculate minimum and maximum volume for sample */
  assert(ws.bytes_per_sample != 0);
  if (ws.bytes_per_sample == 1) { /* 8 bit samples */
    ws.min_vol = 0;
    ws.max_vol = 255;
  } else { /* 16 bit or higher samples */
    ws.min_vol = -(int32_t)pow(2, ws.bytes_per_sample * 8 - 1);
    ws.max_vol = -ws.min_vol - 1;
    /* expand or remove assert if need to support samples 24-bit or higher */
    assert((ws.bytes_per_sample == 2) && (ws.min_vol == -32768) &&
           (ws.max_vol == 32767));
  }

  if (rom_type == MEGAROM) {
    fprintf(stderr,
            "WARNING: cas file generation is not supported for MEGAROM\n");
    return;
  }

  if ((rom_type == ROM) && (start_address < 0x8000)) {
    fprintf(stderr,
            "WARNING: cas file generation is not supported for ROM that start "
            "below address 0x8000. Current start address is %#06x\n",
            start_address);
    return;
  }

  build_tape_file_name(fname_msx, _fname_msx);
  assert(strlen(_fname_msx) == FNAME_MSX_LEN);

  if (cas_flags & 1) /* check if bit 0 is set, i.e. need to generate cas */
  {
    strcpy(fname_cas, fname_no_ext);
    strcat(fname_cas, ".cas");
    printf("cas file %s\n", fname_cas);
    casf = fopen(fname_cas, "wb");
    if (!casf) {
      fprintf(stderr, "ERROR: can't create file %s in %s\n", fname_cas,
              __func__);
      exit(1);
    }
  }

  if (cas_flags & 2) /* check if bit 1 is set, i.e. need to generate wav */
  {
    size_t rc;

    strcpy(fname_wav, fname_no_ext);
    strcat(fname_wav, ".wav");
    wavf = fopen(fname_wav, "wb");
    if (!wavf) {
      fprintf(stderr, "ERROR: can't create file %s in %s\n", fname_wav,
              __func__);
      exit(1);
    }

    /* build the wav file header */
    assert(sizeof(wh) == 44);
    wh.chunk_id = MKFOURCC('R', 'I', 'F', 'F'); /* "RIFF" */
    wh.chunk_size =
        -1; /* file size - 8 (8 == sizeof(chunk_id) + sizeof(chunk_size)) */
    wh.format = MKFOURCC('W', 'A', 'V', 'E');       /* "WAVE" */
    wh.subchunk1_id = MKFOURCC('f', 'm', 't', ' '); /* "fmt " */
    wh.subchunk1_size = sizeof(wh.audio_format) + sizeof(wh.num_channels) +
                        sizeof(wh.sample_rate) + sizeof(wh.byte_rate) +
                        sizeof(wh.block_align) + sizeof(wh.bits_per_sample);
    assert(wh.subchunk1_size == 16);              /* this should always be 16 */
    wh.audio_format = 1;                          /* 1: PCM */
    wh.num_channels = ws.num_channels;            /* 1 or 2 */
    wh.sample_rate = ws.sample_rate;              /* 22050, 44100 or 48000 */
    wh.bits_per_sample = 8 * ws.bytes_per_sample; /* 8 or 16 */
    wh.block_align = wh.num_channels * (wh.bits_per_sample / 8);
    wh.byte_rate = wh.sample_rate * wh.block_align;
    wh.subchunk2_id = MKFOURCC('d', 'a', 't', 'a'); /* "data" */
    wh.subchunk2_size =
        -1; /* samples_count * num_channels * (bits_per_sample / 8) */

    /* write WAV header  */
    rc = fwrite(&wh, sizeof(struct WavHeader), 1, wavf);
    assert(rc == 1);
  }

  /* write a long header at the start of the program on tape */
  tape_long_header(casf, wavf, &ws);

  if ((rom_type == BASIC) ||
      (rom_type == ROM)) /* BASIC block is not implemented in asMSX */
  {
    for (i = 0; i < 10; i++)
      tape_write_byte(0xd0, casf, wavf, &ws);

    for (i = 0; i < (int)strlen(_fname_msx); i++)
      tape_write_byte(_fname_msx[i], casf, wavf, &ws);

    /* write a short header at the start of the binary block */
    tape_short_header(casf, wavf, &ws);

    tape_write_byte(start_address & 0xff, casf, wavf, &ws);
    tape_write_byte((start_address >> 8) & 0xff, casf, wavf, &ws);
    tape_write_byte(end_address & 0xff, casf, wavf, &ws);
    tape_write_byte((end_address >> 8) & 0xff, casf, wavf, &ws);
    tape_write_byte(run_address & 0xff, casf, wavf, &ws);
    tape_write_byte((run_address >> 8) & 0xff, casf, wavf, &ws);
  }
  //	else if (type == Z80)
  //	{
  //		wav_size = (3968 * 1 + 1500 * 1 + 11 * (end_address - start_address
  //+ 1)) * 36; 		wav_size = wav_size << 1;
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

  for (i = start_address; i <= end_address; i++)
    tape_write_byte(rom_buf[i], casf, wavf, &ws);

  if (casf)
    fclose(casf);

  if (wavf) {
    size_t rc;

    /* check if samples are 8-bit and total number of samples is odd */
    if ((ws.bytes_per_sample == 1) && (ws.samples_count & 1)) {
      fputc(0, wavf); /* pad wav file with a 0 byte */
      ws.samples_count++;
    }

    wh.subchunk2_size =
        ws.samples_count * ws.num_channels * ws.bytes_per_sample;

    /* wav header size (44) - size of first two fields (8) + subchunk2_size */
    wh.chunk_size = sizeof(struct WavHeader) -
                    (sizeof(wh.chunk_id) + sizeof(wh.chunk_size)) +
                    wh.subchunk2_size;

    /* overwrite header with proper values for chunk_size and subchunk2_size
     * based on ws.samples_count */
    fseek(wavf, 0, SEEK_SET);

    rc = fwrite(&wh, sizeof(struct WavHeader), 1, wavf);
    assert(rc == 1);

    fclose(wavf);
    printf("Audio file %s saved [%2.2f sec]\n", fname_wav,
           (double)ws.samples_count /
               (ws.sample_rate * ws.num_channels * ws.bytes_per_sample));
  }
}

/*
 Deterministic version of rand() to keep generated binary files
 consistent across platforms and compilers. Code snippet is from
 http://stackoverflow.com/questions/4768180/rand-implementation
*/
static unsigned long int rand_seed = 1;
int d_rand(void) {
  rand_seed = (rand_seed * 1103515245 + 12345);
  return (unsigned int)(rand_seed / 65536) % (32767 + 1);
}

// Function for errors
void error_message(int n, char *fname_src, int lines) {
  fflush(stdout); // Flush output so error is in the end.
  switch (n) {
  case 0:
    sprintf(error_buffer, "syntax error\n");
    break;
  case 1:
    sprintf(error_buffer, "memory overflow\n");
    break;
  case 2:
    sprintf(error_buffer, "wrong register combination\n");
    break;
  case 3:
    sprintf(error_buffer, "wrong interruption mode\n");
    break;
  case 4:
    sprintf(error_buffer, "destiny register should be A\n");
    break;
  case 5:
    sprintf(error_buffer, "source register should be A\n");
    break;
  case 6:
    sprintf(error_buffer, "value should be 0\n");
    break;
  case 7:
    sprintf(error_buffer, "missing condition\n");
    break;
  case 8:
    sprintf(error_buffer, "unreachable address\n");
    break;
  case 9:
    sprintf(error_buffer, "wrong condition\n");
    break;
  case 10:
    sprintf(error_buffer, "wrong restart address\n");
    break;
  case 11:
    sprintf(error_buffer, "symbol table overflow\n");
    break;
  case 12:
    sprintf(error_buffer, "undefined identifier\n");
    break;
  case 13:
    sprintf(error_buffer, "undefined local label\n");
    break;
  case 14:
    sprintf(error_buffer, "symbol redefinition\n");
    break;
  case 15:
    sprintf(error_buffer, "size redefinition\n");
    break;
  case 16:
    sprintf(error_buffer, "reserved word used as identifier\n");
    break;
  case 17:
    sprintf(error_buffer, "code size overflow\n");
    break;
  case 18:
    sprintf(error_buffer, "binary file not found\n");
    break;
  case 19:
    sprintf(error_buffer, "ROM directive should preceed any code\n");
    break;
  case 20:
    sprintf(error_buffer, "type previously defined\n");
    break;
  case 21:
    sprintf(error_buffer, "BASIC directive should preceed any code\n");
    break;
  case 22:
    sprintf(error_buffer, "page out of range\n");
    break;
  case 23:
    sprintf(error_buffer, "MSXDOS directive should preceed any code\n");
    break;
  case 24:
    sprintf(error_buffer, "no code in the whole file\n");
    break;
  case 25:
    sprintf(error_buffer, "only available for MSXDOS\n");
    break;
  case 26:
    sprintf(error_buffer, "machine not defined\n");
    break;
  case 27:
    sprintf(error_buffer, "MegaROM directive should preceed any code\n");
    break;
  case 28:
    sprintf(error_buffer, "cannot write ROM code/data to page 3\n");
    break;
  case 29:
    sprintf(error_buffer, "included binary shorter than expected\n");
    break;
  case 30:
    sprintf(error_buffer, "wrong number of bytes to skip/include\n");
    break;
  case 31:
    sprintf(error_buffer, "megaROM subpage overflow\n");
    break;
  case 32:
    sprintf(error_buffer,
            "subpage 0 can only be defined by megaROM directive\n");
    break;
  case 33:
    sprintf(error_buffer, "unsupported mapper type\n");
    break;
  case 34:
    sprintf(error_buffer, "megaROM code should be between 4000h and BFFFh\n");
    break;
  case 35:
    sprintf(error_buffer, "code/data without subpage\n");
    break;
  case 36:
    sprintf(error_buffer, "megaROM mapper subpage out of range\n");
    break;
  case 37:
    sprintf(error_buffer, "megaROM subpage already defined\n");
    break;
  case 38:
    sprintf(error_buffer, "Konami megaROM forces page 0 at 4000h\n");
    break;
  case 39:
    sprintf(error_buffer, "megaROM subpage not defined\n");
    break;
  case 40:
    sprintf(error_buffer, "megaROM-only macro used\n");
    break;
  case 41:
    sprintf(error_buffer, "only for ROMs and megaROMs\n");
    break;
  case 42:
    sprintf(error_buffer, "ELSE without IF\n");
    break;
  case 43:
    sprintf(error_buffer, "ENDIF without IF\n");
    break;
  case 44:
    sprintf(error_buffer, "Cannot nest more IF's\n");
    break;
  case 45:
    sprintf(error_buffer, "IF not closed\n");
    break;
  case 46:
    sprintf(error_buffer, "Sinclair directive should preceed any code\n");
    break;
  case 47:
    sprintf(error_buffer, "Parser memory overflow. Hint: check that all\
 the quotes are closed\n");
    break;
  default:
    sprintf(error_buffer, "Unexpected error code %d\n", n);
  }
  if (lines >= 0) {
    fprintf(stderr, "%s, line %d: %s", strtok(fname_src, "\042"), lines,
            error_buffer);
  } else {
    fprintf(stderr, "%s", error_buffer);
  }
  remove("~tmppre.?");
  exit(n + 1);
}

void warning_message(int n, char *fname_src, int lines, int pass,
                     int *warnings) {
  if (pass != 2)
    return;

  switch (n) {
  case 0:
    sprintf(error_buffer, "undefined error\n");
    break;
  case 1:
    sprintf(error_buffer, "16-bit overflow. Cropping to fit 16 bits. If it's a label, it may not be defined.\n");
    break;
  case 2:
    sprintf(error_buffer, "8-bit overflow. Cropping to fit 8 bits. If it's a label, it may not be defined.\n");
    break;
  case 3:
    sprintf(error_buffer, "3-bit overflow. Cropping to fit 3 bits. If it's a label, it may not be defined.\n");
    break;
  case 4:
    sprintf(error_buffer, "output cannot be converted to CAS\n");
    break;
  case 5:
    sprintf(error_buffer, "non official Zilog syntax\n");
    break;
  case 6:
    sprintf(error_buffer, "undocumented Zilog instruction\n");
    break;
  default:
    sprintf(error_buffer, "unexpected warning %d\n", n);
  }

  fprintf(stderr, "%s, line %d: Warning: %s", strtok(fname_src, "\042"), lines,
          error_buffer);
  warnings++;
}

// Safe version of strcat that checks if there is an overflow
//
char *safe_strcat(char *dest, char *orig, unsigned int max_size,
                  char *fname_src, int lines) {
  if ((strlen(dest) + strlen(orig)) > max_size) {
    error_message(47, fname_src, lines);
  }
  strcat(dest, orig);
  return (dest);
}



// https://www.geeksforgeeks.org/c-program-replace-word-text-another-given-word/
// C program to search and replace 
// all occurrences of a word with 
// other word. 
  
// Function to replace a string with another 
// string 
char* replaceWord(const char* s, const char* oldW, const char* newW, int *num_subs) { 
    char* result; 
    int i, cnt = 0; 
    int newWlen = strlen(newW); 
    int oldWlen = strlen(oldW); 
  
    // Counting the number of times old word 
    // occur in the string 
    for (i = 0; s[i] != '\0'; i++) { 
        if (strstr(&s[i], oldW) == &s[i]) { 
            cnt++; 
  
            // Jumping to index after the old word. 
            i += oldWlen - 1; 
        } 
    } 

    (*num_subs) = cnt;
  
    // Making new string of enough length 
    result = (char*)malloc(i + cnt * (newWlen - oldWlen) + 1); 
  
    i = 0; 
    while (*s) { 
        // compare the substring with the result 
        if (strstr(s, oldW) == s) { 
            strcpy(&result[i], newW); 
            i += newWlen; 
            s += oldWlen; 
        } 
        else
            result[i++] = *s++; 
    } 
  
    result[i] = '\0'; 
    return result; 
} 
 
