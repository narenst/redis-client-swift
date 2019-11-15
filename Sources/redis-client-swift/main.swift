let hostname = "127.0.0.1"
let port = 6379

print("Starting...")
do {
    let redis = try Redis(host: hostname, port: port)
    
    // Ping
    let ping_result = try redis.ping()
    print(ping_result)
    
    // GET
    let key_name = "TEST1"
    let get_result = try redis.get(key: key_name)
    print(get_result!)
    
    // SET
    let random_value = String(Int.random(in: 1..<100))
    let set_result = try redis.set(key: key_name, value: random_value)
    print(set_result)
}
catch {
    print("Error: \(error)")
}
