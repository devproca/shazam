module Ptime :
  sig
    type span = Ptime.span
    module Span = Ptime.Span
    type t = Ptime.t
    val v : int * int64 -> t
    val epoch : t
    val min : t
    val max : t
    val of_span : span -> t option
    val to_span : t -> span
    val unsafe_of_d_ps : int * int64 -> t
    val of_float_s : float -> t option
    val to_float_s : t -> float
    val truncate : frac_s:int -> t -> t
    val frac_s : t -> span
    val equal : t -> t -> bool
    val compare : t -> t -> int
    val is_earlier : t -> than:t -> bool
    val is_later : t -> than:t -> bool
    val add_span : t -> span -> t option
    val sub_span : t -> span -> t option
    val diff : t -> t -> span
    type tz_offset_s = int
    type date = tz_offset_s * tz_offset_s * tz_offset_s
    type time = (tz_offset_s * tz_offset_s * tz_offset_s) * tz_offset_s
    val of_date_time : date * time -> t option
    val to_date_time : ?tz_offset_s:tz_offset_s -> t -> date * time
    val of_date : date -> t option
    val to_date : t -> date
    val weekday :
      ?tz_offset_s:tz_offset_s ->
      t -> [ `Fri | `Mon | `Sat | `Sun | `Thu | `Tue | `Wed ]
    type error_range = tz_offset_s * tz_offset_s
    type rfc3339_error =
        [ `Eoi | `Exp_chars of char list | `Invalid_stamp | `Trailing_input ]
    val pp_rfc3339_error : Format.formatter -> rfc3339_error -> unit
    val rfc3339_error_to_msg :
      ('a, [ `RFC3339 of error_range * rfc3339_error ]) result ->
      ('a, [> `Msg of string ]) result
    val of_rfc3339 :
      ?strict:bool ->
      ?sub:bool ->
      ?start:int ->
      string ->
      (t * tz_offset_s option * int,
       [> `RFC3339 of error_range * rfc3339_error ])
      result
    val to_rfc3339 :
      ?space:bool -> ?frac_s:int -> ?tz_offset_s:tz_offset_s -> t -> string
    val pp_rfc3339 :
      ?space:bool ->
      ?frac_s:int ->
      ?tz_offset_s:tz_offset_s -> unit -> Format.formatter -> t -> unit
    val pp_human :
      ?frac_s:int ->
      ?tz_offset_s:tz_offset_s -> unit -> Format.formatter -> t -> unit
    val pp : Format.formatter -> t -> unit
    val dump : Format.formatter -> t -> unit
    val to_yojson : t -> Yojson.Safe.t
    val float_to_ptime_exn : float -> t
    val of_yojson : Yojson.Safe.t -> (t, string) result
  end
module Severity :
  sig
    type t = Info | Warn | Error | Other
    val to_string : t -> string
    val of_string : string -> t
    val of_int : int -> t
    val of_yojson : Yojson.Safe.t -> (t, string) result
    val to_yojson : t -> Yojson.Safe.t
  end
module Log :
  sig
    type t = {
      id : string;
      severity : Severity.t;
      log : string;
      app : string;
      date : Ptime.t;
    }
    val to_yojson : t -> Yojson.Safe.t
    val of_yojson : Yojson.Safe.t -> t Ppx_deriving_yojson_runtime.error_or
  end
val log_table : (string, Log.t) Hashtbl.t
val insert_log : log:Log.t -> unit
val find_all_logs : unit -> Log.t list
val find_by_app : app:string -> Log.t list
val find_by_severity : severity:Severity.t -> Log.t list
val find_logs_since : since:Ptime.t -> Log.t list
