use std::io;


pub(crate) fn encrypt(key_alias: &String, plaintext: &String) {
    println!("Encrypting plaintext '{plaintext}' for '{key_alias}'");
}

pub fn decrypt() -> () {
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer).unwrap();
    println!("received {buffer} to decrypt");
}