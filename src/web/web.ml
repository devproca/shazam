module Database = Db
module Log = Db.Log

module type SimpleRender = sig val render : unit -> string end

let render_simple (module R : SimpleRender) = 
  R.render |> Template.render |> Dream.html

let placeholder = fun _ -> Dream.html "Hello World"

let insert_log log =
  let%lwt body = log in
  let l = Log.of_yojson @@ Yojson.Safe.from_string body in
  match l with
  | Ok l -> Db.insert_log ~log:l; Dream.respond ~code:201 ""
  | Error _ -> Dream.respond ~code:401 ""

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.scope "/api/v1/logs" [] [
      Dream.get "/" (fun _ -> Db.find_all_json () |> Yojson.Safe.to_string |> Dream.json);
      Dream.get "/app/:app" (fun request ->
        let app = Dream.param request "app" in
          Database.find_by_app_json ~app:app |> Yojson.Safe.to_string |> Dream.json);
      Dream.get "/severity/:severity" placeholder;
      Dream.get "/date/:date" placeholder;
      Dream.post "/" (fun request -> insert_log @@ Dream.body request)
    ];
    Dream.scope "/" [] [
      Dream.get "/" (fun _ -> render_simple (module Home));
      Dream.get "/app/:app" (fun request ->
          App.render ~app:(Dream.param request "app") |> Template.render |> Dream.html
        );
    ];
    Dream.get "/**"  (fun request -> Dream.redirect request "/")
  ]