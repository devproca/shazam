module Database = Db
module Log = Db.Log

let save log = 
  Database.insert_log ~log:log

let add_log req =
  let%lwt body = Dream.body req in
  let log = Log.of_yojson @@ Yojson.Safe.from_string body in
  match log with
  | Ok l -> Db.insert_log ~log:l; Dream.respond ~code:201 ""
  | Error _ -> Dream.respond ~code:401 ""

let get_all () =
  let logs = Database.find_all_logs () in
    `List (List.map Db.Log.to_yojson logs) |> Yojson.Safe.to_string |> Dream.json

let get_by_app app = 
  let logs = Database.find_by_app ~app:app in
    `List (List.map Db.Log.to_yojson logs) |> Yojson.Safe.to_string |> Dream.json

module type Render = sig val render : unit -> string end

let render (module R : Render) = 
  R.render |> Template.render |> Dream.html

let placeholder = fun _ -> Dream.html "Hello World"

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> render (module Home));
    Dream.scope "/logs" [] [
      Dream.get "/" (fun _ -> get_all ());
      Dream.get "/app/:app" (fun request ->
        get_by_app @@ Dream.param request "app");
      Dream.get "/severity/:severity" placeholder;
      Dream.get "/date/:date" placeholder;
      Dream.post "/" add_log;
    ];
    Dream.get "/**" 
      (fun request ->
        Dream.redirect request "/");
  ]