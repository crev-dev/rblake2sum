use std::path::PathBuf;

use clap::Parser;

#[derive(Parser, Debug, Clone)]
#[command(author, version, about, long_about = None)]
pub struct Opts {
    #[arg(long = "base64")]
    pub base64: bool,
    #[arg(required = true)]
    pub paths: Vec<PathBuf>,
}
