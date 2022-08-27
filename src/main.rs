mod lib;

use lib::{decrypt, encrypt};

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[clap(author, version, about, long_about = None)]
#[clap(propagate_version = true)]
struct Cli {
    #[clap(subcommand)]
    command: Commands,
    #[clap(short, long, value_parser, default_value_t = String::from("eu-west-1"))]
    region: String,
}

#[derive(Subcommand)]
enum Commands {
    /// Encrypt plaintext using a KMS key
    Encrypt {
        #[clap(short, long, value_parser)]
        key_alias: String,
        #[clap(short, long, value_parser)]
        plaintext: String,
    },
    /// Decrypt ciphertext from STDIN
    Decrypt {},
}

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Commands::Encrypt {
            key_alias,
            plaintext,
        } => encrypt(key_alias, plaintext, cli.region),
        Commands::Decrypt {} => decrypt(cli.region),
    }
}
