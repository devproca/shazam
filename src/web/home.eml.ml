let render () =
  let logs = Db.group_by_app ~logs:(Db.find_all_logs ()) in
  <h1>Dev-Pro Logging</h1>
  <div>
  <% logs |> List.iter begin fun (grouped_logs : Db.GroupedLogs.t) -> %>
    <h3><a href="/app/<%s grouped_logs.app %>"><%s grouped_logs.app %></a></h3>
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