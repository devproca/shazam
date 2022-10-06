let render () =
  let logs = Db.group_by_app ~logs:(Db.find_all_logs ()) in
  <h1>Dev-Pro Logging</h1>
  <p class="mb-3 mt-3">Click an app for real time logging.</p>
  <% logs |> List.iter begin fun (grouped_logs : Db.GroupedLogs.t) -> %>
    <div class="card">
    <div class="card-body" id="<%s grouped_logs.app %>">
    <h3 class="card-title"><a href="/app/<%s grouped_logs.app %>"><%s grouped_logs.app %></a></h3>
    <div class="scroll">
    <% grouped_logs.logs |> List.iter begin fun (log : Db.Log.t) -> %>
      <%s! Log.render ~log:log () %>
    <% end; %>
    </div>
    </div>
  </div>
  <% end; %>