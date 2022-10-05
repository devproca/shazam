module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

type t = {
  up : (module DB) -> unit Lwt.t;
  down : (module DB) -> unit Lwt.t;
}

let make_migration ~mig =
  let open Caqti_request.Infix in
  let q = T.unit -->. T.unit @:- mig in
  fun (module DB : DB) ->
    let%lwt unit_or_error = DB.exec q () in
    Caqti_lwt.or_fail unit_or_error

let migrations = [
  { up = make_migration ~mig:{sql|CREATE TABLE IF NOT EXISTS log (
      severity INT NOT NULL,
      log TEXT NOT NULL,
      app TEXT NOT NULL,
      date TIMESTAMP DEFAULT (strftime('%s', 'now')))|sql};
    down = make_migration ~mig:{sql|DROP TABLE log|sql};
  }
]

let migrate_up (module Db : DB) =
  Lwt_list.iter_s (fun mig -> mig.up (module Db)) migrations