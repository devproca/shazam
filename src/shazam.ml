module Db = Db.Database
module Web = Web

let _ = Lwt_main.run (Db.migrate ())

let () = Web.run ()