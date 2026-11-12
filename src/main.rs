cat << 'EOF' > src/main.rs
use sha2::{Digest, Sha256};

trait DataSource {
    fn fetch(&self) -> String;
}

struct CorporateServer {
    seed: String,
}

impl DataSource for CorporateServer {
    fn fetch(&self) -> String {
        self.seed.clone()
    }
}

fn generate_key(seed: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(seed.as_bytes());
    let digest = hasher.finalize();
    digest.iter().map(|b| format!("{b:02x}")).collect()
}

fn forge_key_from_source(source: &dyn DataSource) -> Result<String, &'static str> {
    let seed = source.fetch();
    if seed.trim().is_empty() {
        return Err("Помилка: джерело повернуло порожній сід");
    }
    Ok(generate_key(&seed))
}

fn main() {
    let server = CorporateServer {
        seed: String::from("vtfk-sid-perimeter-b7"),
    };

    match forge_key_from_source(&server) {
        Ok(key) => println!("Generated SHA-256 key: {}", key),
        Err(err) => eprintln!("{}", err),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    struct MockDataSource {
        canned_response: String,
    }

    impl DataSource for MockDataSource {
        fn fetch(&self) -> String {
            self.canned_response.clone()
        }
    }

    #[test]
    fn generate_key_is_deterministic() {
        assert_eq!(generate_key("alpha"), generate_key("alpha"));
    }

    #[test]
    fn generate_key_differs_for_different_seed() {
        assert_ne!(generate_key("alpha"), generate_key("beta"));
    }

    #[test]
    fn mock_source_success_scenario() {
        let mock = MockDataSource {
            canned_response: String::from("corp-server-token-42"),
        };
        let result = forge_key_from_source(&mock);
        assert_eq!(result, Ok(generate_key("corp-server-token-42")));
    }

    #[test]
    fn mock_source_empty_error_scenario() {
        let mock = MockDataSource {
            canned_response: String::new(),
        };
        let result = forge_key_from_source(&mock);
        assert!(result.is_err());
    }
}
EOF
cargo test