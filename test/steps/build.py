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
    
@given('I create folder {folder}')
def step_impl(context, folder):
    os.makedirs(folder, exist_ok=True)
    if not hasattr(context, 'created_folders'):
        context.created_folders = []
    context.created_folders.append(folder)

@step('file {file} exists')
@step('file {file} does {should} exist')
def step_impl(context, file, should: str = ""):
    should = (not "no" in should)
    if should:
        assert os.path.isfile(file), f"File {file} does not exist"
    else:
        assert not os.path.isfile(file), f"File {file} does exist"

def human_size_to_int(size: str) -> int:
    size = size.lower()
    if size[-1] == 'k':
        return int(size[:-1]) * 1024
    elif size[-1] == 'm':
        return int(size[:-1]) * 1024 * 1024
    elif size.isnumeric():
        return int(size)
    else:
        raise("Value not valid")

@step('file {file} size is {size}')
@step('file size of {file} is {size}')
def step_impl(context, file, size: str):
    expected_size = human_size_to_int(size)
    file_size = os.path.getsize(file)
    assert file_size == expected_size, f"File {file} has size {file_size} (expected {expected_size})"

@given('I write to {file}')
@given('I write the code to {file}')
def step_impl(context, file):
    with open(file, 'w') as f:
        f.write(context.text)

@when('I build {file}')
@when('I build {file} with flag {flag}')
def step_impl(context, file, flag = ""):
    # Fullpath is not needed, we always use relatives to the project
    # fullpath = os.path.abspath(file)
    command = ['asmsx']
    if flag:
        command.extend(flag.split(" "))
    command.append(file)
    context.build_program = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        check=False,
        env=env
    )
    assert context.build_program.returncode == 0, f"Program exited with code {context.build_program.returncode}"
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
        assert output in context.build_program.stdout, f"Output not found:\n{context.build_program.stdout}"
    else:
        assert output not in context.build_program.stdout, f"Output found:\n{context.build_program.stdout}"

@then(u'build {has} warnings')
def step_impl(context, has):
    assert context.build_program, "Program did not run"
    check = ("no" in has)
    if check:
        assert "Warning:" not in context.build_program.stdout, f"Warnings found:\n{context.build_program.stdout}"
    else:
        assert "Warning:" in context.build_program.stdout, f"No warnings found:\n{context.build_program.stdout}"

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

@then('text file contains {text}')
def step_impl(context, text):
    assert context.build_txt, "There's no output text file!"

    with open(context.build_txt, 'r') as text_file:
        if text in text_file.read():
            return True
    assert False, "Text not found in output text"

@then('text file does not contain {text}')
def step_impl(context, text):
    assert context.build_txt, "There's no output text file!"

    with open(context.build_txt, 'r') as text_file:
        if text in text_file.read():
            assert False, "Found text in output text"
    return True
