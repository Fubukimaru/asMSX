from behave import *
import os
import subprocess
import hashlib

env = dict(os.environ)
env["PATH"] = os.getcwd() + ":" + env["PATH"]
parent_dir = os.getcwd()

@given('I jump to folder {folder}')
def step_impl(context, folder):
    os.chdir(parent_dir)
    assert os.path.isdir(folder), "Folder does not exist"
    os.chdir(folder)

@given('file {file} exists')
@when('file {file} exists')
@then('file {file} exists')
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

@when('I invalid build {file}')
def step_impl(context, file):
    fullpath = os.path.abspath(file)
    context.build_program = subprocess.run(
        ['asmsx', fullpath],
        stdout=subprocess.PIPE,
        universal_newlines=True,
        check=False,
        env=env
    )
    assert context.build_program.returncode > 0, "Program did not fail"

@then('error code is {error_code:d}')
def step_impl(context, error_code):
    assert context.build_program, "Program did not run"
    assert context.build_program.returncode == error_code, f"Program exited with code {context.build_program.returncode}"

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
