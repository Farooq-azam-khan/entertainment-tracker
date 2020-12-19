#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
use rocket::response::Redirect;

extern crate dotenv;

use dotenv::dotenv;
use std::env;

use std::collections::HashMap;

#[get("/my-secret")]
fn get_secret() -> String {
        String::from(env::var("MY_SECRET").unwrap().as_str())
}

#[get("/login/github")]
fn github_oauth() -> Redirect {
        let github = format!(
                "https://github.com/login/oauth/authorize?client_id={}&redirect_uri={}",
                env::var("GITHUB_CLIENT_ID").unwrap().as_str(),
                "http://localhost:8001/login/github/callback"
        );
        println!("{:?}", github);

        Redirect::to(github)
}

fn get_access_token(code: String) {
        let github = "https://github.com/login/oauth/access_token";
        /*
        headers {
                "Content-Type": "application/json"
        },
        body: {
                "client_id": env::var("GITHUB_CLIENT_ID").unwrap().as_str(),
                "client_secret": env::var("GITHUB_CLIENT_SECRET").unwrap().as_str(),
                "code": code.as_str()
        }
        */
        let mut map = HashMap::new();
        let client_id = env::var("GITHUB_CLIENT_ID").unwrap();
        let client_secret = env::var("GITHUB_CLIENT_SECRET").unwrap();
        map.insert("client_id", client_id.as_str());
        map.insert("client_secret", client_secret.as_str());
        map.insert("code", code.as_str());
        // map.insert("redirect_uri", "http://localhost:8001/success");
        let client = reqwest::blocking::Client::new();
        let res = client
                .post(github)
                .header("Content-Type", "application/json")
                .json(&map)
                .send();

        println!("{:?}", res);

        // TODO: return access token
        // match res.status() {
        //         reqwest::StatusCode::Ok =>
        // }
}

#[get("/login/github/callback?<code>")]
fn github_callback(code: Option<String>) -> Result<String, Box<dyn std::error::Error>> {
        match code {
                Some(token) => get_access_token(token), // TODO: return json token
                None => println!("no code provided"),
        };
        Ok(String::from("will check some stuff now"))
}

#[get("/")]
fn index() -> &'static str {
        "Hello, World"
}

fn main() {
        dotenv().ok();
        rocket::ignite()
                .mount(
                        "/",
                        routes![index, get_secret, github_oauth, github_callback,],
                )
                .launch();
}
