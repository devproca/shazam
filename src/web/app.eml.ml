let render ~app () =
  let logs = Db.find_by_app ~app:app in 
  <a href="/">Go home</a>
  <div>
    <h3><%s app %></h3>
    <% logs |> List.iter begin fun (log : Db.Log.t) -> %>
%     begin match log.severity with
%     | Db.Severity.Info ->
        <p class="text-primary"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%     | Db.Severity.Error -> 
        <p class="text-error"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%     | Db.Severity.Warn -> 
        <p class="text-warning"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%     | Db.Severity.Other ->
        <p class="text-secondary"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%      end;
    <% end; %>
  </div>