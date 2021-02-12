# kms-utils

A wrapper over [AWS KMS](https://aws.amazon.com/kms/).

## Installation

Download relevant binary  from the [releases page](https://github.com/momirza/kms-utils/releases)
and add to `PATH`.

## Usage

```
Usage: kms-utils COMMAND

Available options:
  -h,--help                Show this help text

Available commands:
  encrypt                  Encrypt plaintext using a KMS key
                             Usage: kms-utils encrypt --key-alias key_alias --plaintext plaintext
                             
  decrypt                  Decrypt ciphertext from STDIN
```

## Notes

- For compiling on macos remove `ld-options: -static` from `package.yaml`
