let render ~(log : Db.Log.t) () =
  let open Db.Severity in
  let color = 
    match log.severity with 
    | Info ->  "text-primary"
    | Error -> "text-danger"
    | Warn -> "text-warning"
    | Other -> "text-secondary"
  in
  <div class="<%s color %>" time="<%s log.date |> Ptime.to_float_s |> string_of_float %>">
    [<%s log.date |> Ptime.to_rfc3339 %>] <%s Db.Severity.to_string log.severity |> String.uppercase_ascii %> - <%s log.log %>
  </div>