from behave import *
import os
import re

use_step_matcher("re")

@then(u'sym address for (?P<name>.+) should be (?P<expected>[0-9A-Fa-f]+)')
def step_impl(context, name, expected):
    """
    Verify that a symbol in the .SYM file has the expected address value.
    This test ensures negative values are properly cropped to 16 bits.
    """
    assert context.build, "There's no build done!"
    assert context.build_sym, "There's no symbols file!"
    file = context.build_sym

    # Match 4-digit hex values only (16-bit), not 8-digit (32-bit)
    symbol = re.compile(r'^(?P<address>[0-9A-F]{4})h (?P<label>.+)$')
    with open(file, 'r') as sym:
        for line in sym:
            data = symbol.match(line)
            if data and data.group('label') == name:
                actual_address = data.group('address')
                assert actual_address.upper() == expected.upper(), \
                    f"Expected {name} to have address {expected}h, but got {actual_address}h"
                return True
    raise AssertionError(f"Label {name} not found in .SYM file")
