module Ptime = struct
  include Ptime

  let to_yojson p : Yojson.Safe.t =
    `Float (to_float_s p)

  let float_to_ptime_exn p =
    match of_float_s p with
    | None -> raise (Invalid_argument "")
    | Some s -> s

  let of_yojson (p : Yojson.Safe.t) =
    match p with
    | `Float f -> Ok (float_to_ptime_exn f)
    | _ -> Error ""
end

module Log = struct
  type t = {
    id : string;
    severity : int;
    log : string;
    app : string;
    date : Ptime.t;
  } [@@deriving yojson]
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