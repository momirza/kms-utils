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

### Encrypt

```
Encrypt plaintext using a KMS key

USAGE:
    kms-utils encrypt --key-alias <KEY_ALIAS> --plaintext <PLAINTEXT>

OPTIONS:
    -h, --help                     Print help information
    -k, --key-alias <KEY_ALIAS>
    -p, --plaintext <PLAINTEXT>
    -V, --version                  Print version information
```

#### Example

```console
kms-utils encrypt --key-alias prod --plaintext foo
```

### Decrypt

#### Example

```console
echo "ciphertext:::..." | kms-utils decrypt 
```

