use aws_config::meta::region::RegionProviderChain;
use aws_sdk_kms::types::Blob;
use aws_sdk_kms::Client;

const DEFAULT_REGION: &str = "eu-west-1";

async fn get_client(region: &'static str) -> Client {
    let region_provider = RegionProviderChain::default_provider().or_else(region);
    let shared_config = aws_config::from_env().region(region_provider).load().await;
    Client::new(&shared_config)
}

#[tokio::main]
pub async fn decrypt(ciphertext: &str) -> String {
    let client = get_client(DEFAULT_REGION).await;
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
pub async fn encrypt(key_id: &String, plaintext: &String) -> String {
    let client = get_client(DEFAULT_REGION).await;

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
