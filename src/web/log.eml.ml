let render ~(log : Db.Log.t) () =
  let open Db.Severity in
  let color = 
    match log.severity with 
    | Info ->  "text-primary"
    | Error -> "text-danger"
    | Warn -> "text-warn"
    | Other -> "text-secondary"
  in
  <div class="<%s color %>">
          [<%s log.date |> Ptime.to_rfc3339 %>] <%s Db.Severity.to_string log.severity %> - <%s log.log %>
  </div>