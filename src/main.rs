#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
use postgres::{Client, Error, NoTls};
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

fn get_access_token(code: String) -> Option<String> {
        let github = "https://github.com/login/oauth/access_token";
        let mut map = HashMap::new();
        let client_id = env::var("GITHUB_CLIENT_ID").unwrap();
        let client_secret = env::var("GITHUB_CLIENT_SECRET").unwrap();
        map.insert("client_id", client_id.as_str());
        map.insert("client_secret", client_secret.as_str());
        map.insert("code", code.as_str());
        let client = reqwest::blocking::Client::new();
        let res = client
                .post(github)
                .header("Content-Type", "application/json")
                // .header("Accept", "application/json")
                .json(&map)
                .send();
        match res {
                Ok(response) => match response.text() {
                        Ok(access_token) => Some(access_token),
                        Err(_err) => None,
                },
                Err(_err) => None,
        }
}

#[get("/login/github/callback?<code>")]
fn github_callback(code: Option<String>) -> Redirect {
        match code {
                Some(token) => {
                        let access_token = get_access_token(token);
                        match access_token {
                                Some(at) => {
                                        // let jsonToken = content::Json(at);
                                        let redirect_to_frontend =
                                                format!("http://localhost:8000/login?{}", at);
                                        println!("sending back to {}", redirect_to_frontend);
                                        Redirect::to(redirect_to_frontend)
                                }
                                None => Redirect::to("http://localhost:8000"),
                        }
                }
                None => Redirect::to("http://localhost:8000/Main.elm"),
        }
}

#[get("/")]
fn index() -> &'static str {
        "Hello, World"
}

fn get_client() -> Result<Client, Error> {
        Ok(Client::connect(
                env::var("DATABASE_URL").unwrap().as_str(),
                NoTls,
        )?)
}
fn connect_to_database() -> Result<(), Error> {
        let result_client = get_client();
        match result_client {
                Ok(mut client) => client.batch_execute(
                        "
                        CREATE TABLE user IF NOT EXISTS (
                                id SERIAL PRIMARY KEY, 
                                name VARCHAR(200), 
                                email VARCHAR(400), 
                                access_token VARCHAR(500)
                        )
                ",
                )?,
                Err(_) => println!("was not able to connect to client"),
        };
        Ok(())
}
fn main() {
        dotenv().ok();

        connect_to_database();
        rocket::ignite()
                .mount(
                        "/",
                        routes![index, get_secret, github_oauth, github_callback,],
                )
                .launch();
}
