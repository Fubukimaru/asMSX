from behave import fixture, use_fixture
import os


def after_scenario(context, scenario):
    extensions = ["bin", "txt", "cas", "sym", "wav", "rom", "z80"]

    # cleanup build temp files
    for i in range(0, 4):
        file = f"~tmppre.{i}"
        if os.path.isfile(file):
            os.remove(file)

    for file in os.listdir(os.getcwd()):
        for extension in extensions:
            if file.endswith(f".{extension}"):
                #print(f"Deleting {file}")
                os.remove(file)
