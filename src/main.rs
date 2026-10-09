use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() > 1 && args[1] == "--pixel" {
        println!("Позивний прийнято. 101.9 FM. Нічна Хвиля на зв'язку.");
        println!("0xC10 підтверджує: пам'ять — це відповідальність.");
        return;
    }
    println!("Ядро С.І.Д. активне.");
}