let render ~app () =
  let logs = Db.find_by_app ~app:app |> List.rev in 
  <div class="mb-3 mt-3">
    <a href="/">Go home</a>
  </div>
% if logs = [] then begin
    <h3 class="m-3">Unknown app <%s app %></h3>
% end else begin
    <div class="card min-vh-50">
    <div class="card-body">
    <h3 class="card-title" id="app-name"><%s app %></h3>
    <div class="d-flex ">
    <div class="scroll w-50" style="margin-right: 15px; height: 400px;" id="logs">
    <% logs |> List.iter begin fun (log : Db.Log.t) -> %>
        <%s! Log.render ~log:log () %>
    <% end; %>
    </div>
    <div class="w-50">
    <canvas id="logChart" width="280" height="h-100"></canvas>
    </div>
    </div>
    </div>
    <script src="/static/realtime.js" rel="script"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js" rel="script" crossorigin="anonymous"></script>
    <script src="/static/chart.js" rel="script"></script>
    </div>
% end;