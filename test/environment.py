from behave import fixture, use_fixture
import os


def after_scenario(context, scenario):
    extensions = ["bin", "txt", "cas", "sym", "wav", "rom", "z80", "com", "ram"]

    # cleanup build temp files
    for i in range(0, 4):
        file = f"~tmppre.{i}"
        if os.path.isfile(file):
            os.remove(file)

    if os.path.isfile("test.asm"):
        os.remove("test.asm")

    for file in os.listdir(os.getcwd()):
        for extension in extensions:
            if file.endswith(f".{extension}"):
                #print(f"Deleting {file}")
                os.remove(file)
