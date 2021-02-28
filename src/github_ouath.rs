#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
use postgres::{Client, Error, NoTls};
use reqwest::header::USER_AGENT;
use rocket::response::content;
use rocket::response::Redirect;
use serde::{Deserialize, Serialize};

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

#[derive(Deserialize, Serialize, Debug)]
struct User {
        name: String,
        email: Option<String>,
}

fn query_github(token: String) -> Option<User> {
        let user_info_url = "https://api.github.com/user";
        let header = format!("token {}", token);
        let client = reqwest::blocking::Client::new();
        let res = client
                .get(user_info_url)
                .header("Authorization", header.as_str())
                .header(USER_AGENT, " Mozilla/5.0")
                .send();

        match res {
                Ok(response) => {
                        // match
                        let json_user: User =
                                serde_json::from_str(response.text().unwrap().as_str()).unwrap();
                        println!("{:?}", json_user);
                        Some(json_user)
                }
                Err(_) => None,
        }
}

#[get("/user/<access_token>")]
fn get_user_information(access_token: Option<String>) -> content::Json<String> {
        match access_token {
                Some(token) => {
                        // fetch user
                        let user = query_github(token).unwrap();
                        // TODO: check database for user

                        content::Json(serde_json::to_string(&user).unwrap())
                }
                None => content::Json(String::from("None")),
        }
}

#[get("/login/github/callback?<code>")]
fn github_callback(code: Option<String>) -> Redirect {
        match code {
                Some(token) => {
                        let access_token = get_access_token(token);
                        match access_token {
                                Some(at) => {
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


