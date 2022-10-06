module Ptime = struct
  include Ptime

  let to_yojson p : Yojson.Safe.t =
    `Float (to_float_s p)

  let float_to_ptime_exn p =
    match of_float_s p with
    | None -> raise (Invalid_argument "Invalid type of time")
    | Some s -> s

  let of_yojson (p : Yojson.Safe.t) =
    match p with
    | `Float f -> Ok (float_to_ptime_exn f)
    | `Int f -> Ok (float_to_ptime_exn (float_of_int f))
    | _ -> Error ""
end

module Severity = struct
  type t =
  | Info
  | Warn
  | Error
  | Other

  let to_string = function
    | Info -> "info"
    | Warn -> "warn"
    | Error -> "error"
    | Other -> "other"

  let of_string f =
    let lower = String.lowercase_ascii f in
    match lower with
    | "info" -> Info
    | "warn" -> Warn
    | "error" -> Error
    | _ -> Other

  let of_int = function
    | 0 -> Info
    | 1 -> Warn
    | 2 -> Error
    | _ -> Other

  let of_yojson (p : Yojson.Safe.t) =
    match p with
    | `Int a -> Ok (of_int a)
    | `String a -> Ok (of_string a)
    | `Float a -> Ok (of_int @@ int_of_float a)
    | _ -> Error "Invalid type for severity"

  let to_yojson (p : t) : Yojson.Safe.t = 
    `String (to_string p)
end

module Log = struct
  type t = {
    id : string;
    severity : Severity.t;
    log : string;
    app : string;
    date : Ptime.t;
  } [@@deriving yojson]
end

module GroupedLogs = struct
  type t = {
    app : string;
    logs : Log.t list;
  }
end

let log_table : (string, Log.t) Hashtbl.t  = Hashtbl.create 512

let insert_log ~(log : Log.t) =
  Hashtbl.add log_table log.id log

let find_all_logs () =
  List.of_seq @@ Hashtbl.to_seq_values log_table

let find_by_app ~app =
  Hashtbl.to_seq_values log_table
  |> Seq.filter (fun (t : Log.t) -> t.app = app)
  |> List.of_seq

let find_by_severity ~severity =
  Hashtbl.to_seq_values log_table
  |> Seq.filter (fun (t : Log.t) -> t.severity = severity)
  |> List.of_seq

let find_logs_since ~since =
  Hashtbl.to_seq_values log_table
  |> Seq.filter (fun (t : Log.t) -> Ptime.is_later t.date ~than:since)
  |> List.of_seq