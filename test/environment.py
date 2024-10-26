from behave import fixture, use_fixture
import os


def after_scenario(context, scenario):
    extensions = ["bin", "txt", "cas", "sym", "wav", "rom", "z80", "com", "ram"]
    this_folder = os.getcwd()

    # cleanup build temp files
    for i in range(0, 4):
        file = f"~tmppre.{i}"
        if os.path.isfile(file):
            os.remove(file)

    if not os.access(this_folder, os.W_OK):
        os.chmod(this_folder, os.stat(this_folder).st_mode | 0o200)

    if os.path.isfile("test.asm"):
        os.remove("test.asm")

    for file in os.listdir(this_folder):
        for extension in extensions:
            if file.endswith(f".{extension}"):
                #print(f"Deleting {file}")
                os.remove(file)
