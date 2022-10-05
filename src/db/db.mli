module Log :
  sig
    type t = { severity : int; log : string; app : string; date : string; }
    val to_yojson : t -> Yojson.Safe.t
    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or
  end
module Q :
  sig
    val log : Log.t Caqti_type.t
    val insert_log : (Log.t, unit, [ `Zero ]) Caqti_request.t
    val find_all_logs :
      (unit, Log.t, [ `Many | `One | `Zero ]) Caqti_request.t
    val find_logs_by_app :
      (string, Log.t, [ `Many | `One | `Zero ]) Caqti_request.t
    val find_by_severity :
      (int, Log.t, [ `Many | `One | `Zero ]) Caqti_request.t
    val find_logs_since :
      (Ptime.t, Log.t, [ `Many | `One | `Zero ]) Caqti_request.t
  end
module Db : Caqti_lwt.CONNECTION
module Database :
  sig
    val insert_log :
      log:Log.t -> (unit, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_all_logs :
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_by_app :
      app:string ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_by_severity :
      severity:int ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val find_logs_since :
      since:Ptime.t ->
      (Log.t list, [> Caqti_error.call_or_retrieve ]) result Lwt.t
    val migrate : unit -> unit Lwt.t
  end
