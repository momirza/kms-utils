mod lib;

use lib::{encrypt, decrypt};

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[clap(author, version, about, long_about = None)]
#[clap(propagate_version = true)]
struct Cli {
    #[clap(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Adds files to myapp
    Encrypt {
        #[clap(short, long, value_parser)]
        key_alias: String,
        #[clap(short, long, value_parser)]
        plaintext: String,
    },
    Decrypt {},
}

fn main() {
    let cli = Cli::parse();

    // You can check for the existence of subcommands, and if found use their
    // matches just as you would the top level cmd
    match &cli.command {
        Commands::Encrypt { key_alias, plaintext } => {
            encrypt(key_alias, plaintext)
        }
        Commands::Decrypt {} => {
            decrypt()
        }
    }
}
