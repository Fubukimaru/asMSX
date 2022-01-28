from behave import *
import os
import re
#import struct

use_step_matcher("re")

CARTDRIGE_HEADER = b"AB"

def get_hex_little(byte):
    return hex(int.from_bytes(byte, "little"))

@then(u'page (?P<page>\d+) (?P<check>has|has not?) cartridge header')
def step_impl(context, page: int, check: bool):
    page = int(page)
    check = (not "no" in check)
    assert context.build, "There's no build done!"
    file = context.build_file.replace(".asm", ".rom")

    with open(file, 'rb') as rom:
        rom.seek(0x4000 * page, 0)
        data = rom.read(2)
        if check:
            assert data == CARTDRIGE_HEADER, f"Page {page} does not contain cartdrige header: {data}"
            context.init = get_hex_little(rom.read(2))
        else:
            assert data != CARTDRIGE_HEADER, f"Page {page} does contain cartdrige header: {data}"

@then(u'sym contains (?P<name>.+)')
def step_impl(context, name):
    assert context.build, "There's no build done!"
    file = context.build_file.replace(".asm", ".sym")

    symbol = re.compile(r'^(?P<address>[0-9A-F]{4})h (?P<label>.+)$')
    with open(file, 'r') as sym:
        for line in sym:
            data = symbol.match(line)
            if data and data.group('label') == name:
                context.sym_address = int(data.group('address'), 16)
                context.sym_label = data.group('label')
                return True
    raise(f"Label {name} not found")

@then(u'stored init matches sym (?P<name>.+)')
def step_impl(context, name):
    assert context.build, "There's no build done!"
    file = context.build_file.replace(".asm", ".sym")

    symbol = re.compile(r'^(?P<address>[0-9A-F]{4})h (?P<label>.+)$')
    with open(file, 'r') as sym:
        for line in sym:
            data = symbol.match(line)
            if data and data.group('label') == name:
                sym_address = hex(int(data.group('address'), 16))
                assert sym_address == context.init, f"Stored init {context.init} does not match address {sym_address}"
                return True
    raise(f"Label {name} not found")
