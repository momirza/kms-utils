use std::io;
use std::io::Read;

mod kms;

use regex::{Captures, Regex};

const CIPHERTEXT_PREFIX: &str = "ciphertext:::";

pub fn encrypt(key_alias: &String, plaintext: &String, region: String) {
    let ciphertext = kms::encrypt(key_alias, plaintext, region.as_str());
    println!("{CIPHERTEXT_PREFIX}{ciphertext}")
}

pub fn decrypt(region: String) {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer).unwrap();

    let re = Regex::new(r"ciphertext:::(\S*)").unwrap();

    let result = re.replace_all(&buffer, |caps: &Captures| {
        kms::decrypt(&caps[1], region.as_str())
    });

    println!("{result}")
}
