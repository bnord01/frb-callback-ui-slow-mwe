use flutter_rust_bridge::frb;
use std::{collections::HashMap, sync::Mutex};

use crate::frb_generated::StreamSink;

lazy_static::lazy_static! {
    static ref CALLBACKS: Mutex<HashMap<String,StreamSink<(f64, f64)>>> =  Mutex::new(HashMap::new());
}

#[frb(init)]
pub fn lets_init_app_here() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(sync)]
pub fn observe_box(id: String, callback: StreamSink<(f64, f64)>) {
    CALLBACKS.lock().unwrap().insert(id, callback);
}

#[frb(sync)]
pub fn move_box(id: String, x: f64, y: f64) {
    if let Err(e) = CALLBACKS.lock().unwrap().get(&id).unwrap().add((x, y)) {
        println!("Could not send observation of {id}, {e:?}");
    }
}
