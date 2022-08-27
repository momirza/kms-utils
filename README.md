# kms-utils

A wrapper over [AWS KMS](https://aws.amazon.com/kms/).

## Installation

Download relevant binary from
the [releases page](https://github.com/momirza/kms-utils/releases)
and add to `PATH`.

## Usage

```
USAGE:
    kms-utils [OPTIONS] <SUBCOMMAND>

OPTIONS:
    -h, --help               Print help information
    -r, --region <REGION>    [default: eu-west-1]
    -V, --version            Print version information

SUBCOMMANDS:
    decrypt    Decrypt ciphertext from STDIN
    encrypt    Encrypt plaintext using a KMS key
    help       Print this message or the help of the given subcommand(s)
```

## Notes

- For compiling on macos remove `ld-options: -static` from `package.yaml`
