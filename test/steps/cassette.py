from behave import *
import os
#import struct

@then(u'cassette tape name equals {name}')
def step_impl(context, name):
    assert context.build, "There's no build done!"
    file = context.build_file.replace(".asm", ".cas")

    # remove forced quotes
    name = name.replace('"', '')
    with open(file, 'rb') as cassette:
        cassette.seek(18, 0)
        data = cassette.read(6).decode()
        assert data == name, f"Cassette {data} does not match {name}"
