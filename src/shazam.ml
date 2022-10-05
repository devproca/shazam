module Db = Db.Database
module Web = Web

let _ = Db.migrate () 

let () = Web.run ()