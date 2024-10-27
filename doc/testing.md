# asMSX testing guide

We use [behave](https://behave.readthedocs.io/en/stable/) framework for testing.

### Setup

Install `behave`. You may use a virtualenv.<br>
You also need `unix2dos` to fix files.

```sh
pip install behave
sudo apt install dos2unix
```

### Testing

Run `make test` to build `asmsx` and run the tests that are fixed.

You can also execute tests manually:

```sh
# run tests that are fixed
behave test --tags=-wip

# run all tests
behave test
```

### Writing tests

Using `behave`, we define tests with **Gherkin** syntax, available in `test/features` folder.

```
Given we have this status
When we do this
Then we should have this
```

The code for the actual implementation is in `test/steps`.
