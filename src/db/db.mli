module Log :
  sig
    type severity = Error | Info | Warn | Debug | Trace
    type t = {
      severity : severity;
      log : string;
      app : string;
      date : Ptime.t;
    }
  end
module Db : Caqti_lwt.CONNECTION
module Database :
  sig
    val insert_log :
      log:Log.t -> (unit, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_all_logs :
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_logs_by_app :
      app:string ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_by_severity :
      severity:Log.severity ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_logs_since :
      since:Ptime.t ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val migrate : (module Caqti_lwt.CONNECTION) -> unit -> unit Lwt.t
  end
