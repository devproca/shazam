let render param = 
  <html>
  <body>
    <h1>The URL parameter was <%s param %>!</h1>
  </body>
  </html>
  
let run () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.get "/:word"
      (fun request ->
        Dream.param request "word"
        |> render
        |> Dream.html);

  ]