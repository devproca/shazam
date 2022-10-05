module Log = struct
  type severity =
  | Error
  | Info
  | Warn
  | Debug
  | Trace

  let severity_of_int = function
  | 0 -> Info
  | 1 -> Warn
  | 2 -> Error
  | 3 -> Debug
  | 4 -> Trace
  | _ -> raise Not_found

  let int_of_severity = function
  | Info -> 0
  | Warn -> 1
  | Error -> 2
  | Debug -> 3
  | Trace -> 4

  type t = {
    severity : severity;
    log : string;
    app : string;
    date : Ptime.t;
  } [@@ yojson]
end

module Q = struct
  open Caqti_request.Infix
  open Caqti_type.Std

  let log =
    let open Log in
    let encode { severity; log; app; date; } = 
      Ok (int_of_severity severity, log, app, date) in
    let decode (severity, log, app, date) =
      Ok { severity = severity_of_int severity; log; app; date; } in
    let rep = Caqti_type.tup4 Caqti_type.int Caqti_type.string Caqti_type.string Caqti_type.ptime in
    custom ~encode ~decode rep

  let insert_log =
    log ->. unit @@ "INSERT INTO log (severity, log, app, date) VALUES ( ?, ?, ?, ? )"

  let find_all_logs =
    unit ->* log @@ "SELECT * FROM log ORDER BY date DESC"
  
  let find_logs_by_app =
    string ->* log @@ "SELECT * FROM log WHERE app = ? ORDER BY date DESC"

  let find_by_severity =
    int ->* log @@ "SELECT * FROM log WHERE severity = ?"
  
  let find_logs_since =
    ptime ->* log @@ "SELECT * FROM log WHERE date BETWEEN ? AND 'now' ORDER BY date DESC"
end

open Lwt
module Db = (val Caqti_lwt.connect (Uri.of_string "sqlite3:database.db") >>= Caqti_lwt.or_fail |> Lwt_main.run)

module Database = struct
  let insert_log ~log =
    Db.exec Q.insert_log log

  let find_all_logs =
    Db.collect_list Q.find_all_logs ()

  let find_logs_by_app ~app =
    Db.collect_list Q.find_logs_by_app app
  
  let find_by_severity ~severity =
    Db.collect_list Q.find_by_severity (Log.int_of_severity severity)

  let find_logs_since ~since =
    Db.collect_list Q.find_logs_since since


  let migrate (module DB : Caqti_lwt.CONNECTION) () =
    Lwt_list.iter_s (fun (mig : Migration.t) -> mig.up (module DB)) Migration.migrations
end