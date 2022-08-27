use aws_sdk_kms::types::Blob;
use aws_sdk_kms::{Client, Region};

async fn get_client(region: &str) -> Client {
    let shared_config = aws_config::from_env()
        .region(Region::new(region.to_string()))
        .load()
        .await;
    Client::new(&shared_config)
}

#[tokio::main]
pub async fn decrypt(ciphertext: &str, region: &str) -> String {
    let client = get_client(region).await;

    let decoded = base64::decode(ciphertext).unwrap();
    let resp = client
        .decrypt()
        .ciphertext_blob(Blob::new(decoded))
        .send()
        .await
        .unwrap();

    let inner = resp.plaintext.unwrap();
    let bytes = inner.as_ref();

    String::from_utf8(bytes.to_vec()).expect("Could not convert to UTF-8")
}

#[tokio::main]
pub async fn encrypt(key_id: &String, plaintext: &String, region: &str) -> String {
    let client = get_client(region).await;

    let plaintext_blob = Blob::new(plaintext.as_bytes());
    let resp = client
        .encrypt()
        .key_id(format!("alias/cmk-{key_id}"))
        .plaintext(plaintext_blob)
        .send()
        .await
        .unwrap();

    let blob = resp.ciphertext_blob.expect("Could not get encrypted text");
    let bytes = blob.as_ref();

    base64::encode(&bytes)
}
