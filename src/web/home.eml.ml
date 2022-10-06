let render ~logs () =
  <h1>Dev-Pro Logging</h1>
  <div>
  <% logs |> List.iter begin fun (grouped_logs : Db.GroupedLogs.t) -> %>
    <h3><%s grouped_logs.app %></h3>
    <% grouped_logs.logs |> List.iter begin fun (log : Db.Log.t) -> %>
%       begin match log.severity with
%       | Db.Severity.Info ->
          <p class="text-primary"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%       | Db.Severity.Error -> 
          <p class="text-error"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%       | Db.Severity.Warn -> 
          <p class="text-warning"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%       | Db.Severity.Other ->
          <p class="text-secondary"><%s Yojson.Safe.to_string (Db.Log.to_yojson log) %></p>
%       end;
    <% end; %>
  <% end; %>
  </div>