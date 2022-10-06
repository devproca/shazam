let render ~app () =
  let logs = Db.find_by_app ~app:app in 
  <div class="mb-3 mt-3">
    <a href="/">Go home</a>
  </div>
  <div class="card">
    <div class="card-body">
    <h3 class="card-title" id="app-name"><%s app %></h3>
    <div class="" id="logs">
    <% logs |> List.iter begin fun (log : Db.Log.t) -> %>
        <%s! Log.render ~log:log () %>
    <% end; %>
    </div>
    </div>
    <script src="/static/realtime.js" rel="script"></script>
    </div>