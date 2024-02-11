use itertools::Itertools;
use std::collections::HashMap;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Welcome, {name}!")
}

fn crt(remainders: &Vec<u8>, modulos: &Vec<u8>) -> u8 {
    // loop the multiples
    let factor = modulos[0];
    // println!("{:?}", factor);

    let mut i = 1;

    while i < 10 {
        let mut factor = (factor * i) + remainders[0];

        // println!("{}", factor);
        if factor%modulos[1] == remainders[1] && factor%modulos[2] == remainders[2] {
            return factor;
        }

        i = i + 1;
    }

    0
}

#[flutter_rust_bridge::frb(sync)]
pub fn decrypt(key: String, ciphertext: String) -> String {
    let modulos : Vec<u8> = vec![31, 32, 33];
    let base64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    let char_count: HashMap<char, u32> = key
        .chars()
        .into_group_map_by(|&x| x)
        .into_iter()
        .map(|(k, v)| (k, v.len() as u32))
        .collect();

    // println!("{:?}", char_count);

    // let key_vec = vec![195, 294, 666];//&key_vec.iter().copied()
    let key_xor = key.bytes().enumerate().map(|(i, x)| ((x as u32) * ((if i == 0 { 1 } else { i }) as u32) * (key.len() as u32)) / char_count.get(&(x as char)).unwrap()).reduce(|a, b| a ^ b).unwrap();
    let key_binary = modulos.iter().map(|x| (key_xor%(*x as u32)) as u8).reduce(|a, b| a ^ b).unwrap();

    let ciphertext_binary = ciphertext
        .chars()
        .map(|x| format!("{:06b}", base64Table.find(x).unwrap() as u8))
        .join("")
        .chars()
        .chunks(8)
        .into_iter()
        .map(|chunk| u8::from_str_radix(&(chunk.collect::<String>()), 2).unwrap() ^ key_binary)
        .chunks(3)
        .into_iter()
        .map(|rem| crt(&rem.collect::<Vec<u8>>(), &modulos))
        .collect::<Vec<u8>>();

    let text = std::str::from_utf8(&ciphertext_binary).unwrap().to_string();
    println!("{:?}", text);

    text
}

#[flutter_rust_bridge::frb(sync)]
pub fn encrypt(key: String, message: String) -> String {
    let modulos : Vec<u8> = vec![31, 32, 33];
    let mut base64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split("").collect::<Vec<&str>>();

    base64Table.rotate_left(1);

    let char_count: HashMap<char, u32> = key
        .chars()
        .into_group_map_by(|&x| x)
        .into_iter()
        .map(|(k, v)| (k, v.len() as u32))
        .collect();

    // println!("{:?}", char_count);

    // let key_vec = vec![195, 294, 666];//&key_vec.iter().copied()
    let key_xor = key.bytes().enumerate().map(|(i, x)| ((x as u32) * ((if i == 0 { 1 } else { i }) as u32) * (key.len() as u32)) / char_count.get(&(x as char)).unwrap()).reduce(|a, b| a ^ b).unwrap();
    let key_binary = modulos.iter().map(|x| (key_xor%(*x as u32)) as u8).reduce(|a, b| a ^ b).unwrap();

    // println!("{}", key_binary);

    let messages_binary = message.bytes().map(|x| format!("{:08b}{:08b}{:08b}", (x%modulos[0]) ^ key_binary, (x%modulos[1]) ^ key_binary, (x%modulos[2]) ^ key_binary)).reduce(|a, b| format!("{}{}", a, b)).unwrap().chars()
        .chunks(6)
        .into_iter()
        .map(|chunk| base64Table[usize::from_str_radix(&(chunk.collect::<String>()), 2).unwrap()])
        // .collect::<Vec<&str>>()
        .join("");

    println!("{:?}", messages_binary);

    messages_binary
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
