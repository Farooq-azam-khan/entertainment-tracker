use rocket::local::blocking::Client;
use rocket::http::Status; 

fn register_hit(client:&Client) {
    let response = client.get("/").dispatch();
    assert_eq!(response.status(), Status::Ok);
}

fn get_count(client: &Client) {
    let response = client.get("/count").dispatch();
    response.into_string().and_then(|s| s.parse().ok()).unwrap()
}

#[test]
fn test_count() {
    let client = Client::tracked(super::rocket()).unwrap();

    assert_eq!(get_count(&client), 0);

    for _ in 0..99 {
        register_hit(&client);
    }

    assert_eq!(get_count(&client), 99);


    register_hit(&client);
    assert_eq!(get_count(&client), 100); 
}

#[test]
fn test_raw_state_count() {
    use rocket::State;
    use super::{count, index}; 

    let rocket = super::rocket();
    assert_eq!(count(State::from(&rocket).unwrap()), "0");
    assert!(index(State::from(&rocket).unwrap()).0.contains("Visits: 1"));
    assert_eq!(count(State::from(&rocket).unwrap()), "1"); 
}

