module Database = Db.Database
let home = 
  <html>
  <head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
  </head>
  <body>
    <h1>Home Page</h1>
  </body>
  </html>

let save log = 
  Database.insert_log ~log:log
(* let handle_add request =
  let%lwt body = Dream.body request in
    let log = log_of_yojson @@ Yojson.Safe.from_string body in
    match log with
    | Ok l -> save l
    | Error _ -> Dream.respond ~code:500 "" *)

(* let get f param =
  let%lwt logs = f param in
  match logs with
  | Ok lst -> `List lst |> Yojson.Safe.to_string |> Dream.json
  | Error _ -> Dream.respond ~code:404 "" *)

let get_all () =
  (* get Database.find_all_logs () *)
  let%lwt logs = Database.find_all_logs in
  match logs with
  | Ok lst -> `List (List.map Db.Log.to_yojson lst) |> Yojson.Safe.to_string |> Dream.json
  | Error _ -> Dream.respond ~code:404 ""

let get_by_app app = 
  (* get Database.find_by_app app *)
  let%lwt logs = Database.find_by_app ~app:app in
  match logs with
  | Ok lst -> `List (List.map Db.Log.to_yojson lst) |> Yojson.Safe.to_string |> Dream.json
  | Error _ -> Dream.respond ~code:404 ""

let placeholder = fun _ -> Dream.html "Hello World"
let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html home);
    Dream.scope "/logs" [] [
      Dream.get "/" (fun _ -> get_all ());
      Dream.get "/app/:app" (fun request ->
        get_by_app @@ Dream.param request "app");
      Dream.get "/severity/:severity" placeholder;
      Dream.get "/date/:date" placeholder;
    ];
    Dream.get "/**" 
      (fun request ->
        Dream.redirect request "/");
    (* Dream.post "/" handle_add *)
      
  ]