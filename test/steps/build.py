from behave import *
import os
import subprocess
import hashlib
import re

env = dict(os.environ)
env["PATH"] = os.getcwd() + ":" + env["PATH"]
parent_dir = os.getcwd()

@given('I jump to folder {folder}')
def step_impl(context, folder):
    os.chdir(parent_dir)
    assert os.path.isdir(folder), "Folder does not exist"
    os.chdir(folder)

@step('file {file} exists')
def step_impl(context, file):
    assert os.path.isfile(file), f"File {file} does not exist"

@given('I write to {file}')
@given('I write the code to {file}')
def step_impl(context, file):
    with open(file, 'w') as f:
        f.write(context.text)

@when('I build {file}')
def step_impl(context, file):
    fullpath = os.path.abspath(file)
    context.build_program = subprocess.run(
        ['asmsx', fullpath],
        stdout=subprocess.PIPE,
        universal_newlines=True,
        check=True,
        env=env
    )
    context.build = True
    context.build_file = file

    output_list = {
        "txt": "Output text file {} saved",
        "bin": "Binary file {} saved",
        "rom": "Binary file {} saved",
        "cas": "cas file {}",
        "wav": "Audio file {} saved",
        "sym": "Symbol file {} saved",
    }

    for ext, text in output_list.items():
        outfile = re.search(
            text.format('(?P<file>.+)'),
            context.build_program.stdout
        )
        if outfile:
            setattr(context, f"build_{ext}", outfile.group('file'))

@when('I invalid build {file}')
def step_impl(context, file):
    fullpath = os.path.abspath(file)
    context.build_program = subprocess.run(
        ['asmsx', fullpath],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        check=False,
        env=env
    )
    assert context.build_program.returncode > 0, "Program did not fail"

@step('I run command {command}')
def step_impl(context, command):
    subprocess.run(command.split(' '), check=False)

@then('error code is {error_code:d}')
def step_impl(context, error_code):
    assert context.build_program, "Program did not run"
    assert context.build_program.returncode == error_code, f"Program exited with code {context.build_program.returncode}"

@then('build output {should} contain {output}')
def step_impl(context, should, output):
    assert context.build_program, "Program did not run"
    should = (not "no" in should)
    if should:
        assert output in context.build_program.stdout, "Output not found: {context.build_program.stdout}"
    else:
        assert output not in context.build_program.stdout, "Output found: {context.build_program.stdout}"

@then('{file} matches sha {expected_hash}')
def step_impl(context, file, expected_hash):
    buffer_size = 64*1024
    sha1 = hashlib.sha1()

    with open(file, 'rb') as stream:
        while True:
            data = stream.read(buffer_size)
            if not data:
                break
            sha1.update(data)

    assert sha1.hexdigest() == expected_hash, f"Hash {sha1.hexdigest()} does not match"