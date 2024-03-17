# Fuzzing with Echidna

**Step to reproduce**
```shell

docker run -it -v "$PWD":/home/training trailofbits/eth-security-toolbox
solc-select use 0.8.21
cd /home/training
echidna Test.sol --config echidna.yaml --contract Test
```
