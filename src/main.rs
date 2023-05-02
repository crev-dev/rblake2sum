use base64::Engine;
use clap::Parser;

mod opts;

fn main() -> anyhow::Result<()> {
    let opts = opts::Opts::parse();

    for path in opts.paths {
        let digest = crev_recursive_digest::RecursiveDigest::<blake2::Blake2b512, _, _>::new()
            .build()
            .get_digest_of(&path)?;

        println!(
            "{} {}",
            if opts.base64 {
                base64::engine::general_purpose::URL_SAFE.encode(&digest)
            } else {
                hex::encode(digest)
            },
            path.display()
        );
    }
    Ok(())
}
