let home = 
  <html>
  <body>
    <h1>Home Page</h1>
  </body>
  </html>

let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/"
      (fun _ ->
        Dream.html home);

    Dream.get "/**" 
      (fun request ->
        Dream.redirect request "/")
  ]