#include "gtest/gtest.h"

extern "C"
{
	#include "asmsx.h"
	void build_tape_file_name(const char*, char*);
}

TEST(Tape, build_tape_file_name)
{
	char outstr[FNAME_MSX_LEN + 1];

	/* test that 6 character string isn't modified */
	build_tape_file_name("123456", outstr);
	EXPECT_STREQ(outstr, "123456");

	/* test that string longer than 6 character is truncated to first 6 characters */
	build_tape_file_name("1234567890", outstr);
	EXPECT_STREQ(outstr, "123456");

	/* test that string shorter than 6 character is padded with spaces at the end */
	build_tape_file_name("123", outstr);
	EXPECT_STREQ(outstr, "123   ");

	/* test that given empty string as input, function output is 6 spaces */
	build_tape_file_name("", outstr);
	EXPECT_STREQ(outstr, "      ");

	/* test that given NULL as input, function output is 6 spaces */
	build_tape_file_name(NULL, outstr);
	EXPECT_STREQ(outstr, "      ");
}
