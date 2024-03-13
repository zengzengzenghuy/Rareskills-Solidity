# Testing report

## Gas report
1. Run `forge test --gas-report`


## forge coverage

1. Run `forge coverage --report lcov`, it will create lcov.info file
1. Run `genhtml -o report --branch-coverage lcov.info` to generate html
3. Preview the html from /report/src/index.html


## Slither
1. Run `slither .`

# Vertigo-rs
1. git clone `https://github.com/RareSkills/vertigo-rs`
```shell

python3 -m venv venv
source venv/bin/activate  # On Linux/macOS

python3 setup.py develop
cd <your foundry repo>

python3 <path-to-this-project>/vertigo-rs/vertigo.py run
```