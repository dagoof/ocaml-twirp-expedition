exception Twirp_Error of string

let (>>>) f g x = g @@ f x

let response_is_success =
  Cohttp.(Response.status >>> Code.code_of_status >>> Code.is_success)

let do_protobuf_request url bytes =
  let open Lwt in
  let open Cohttp_lwt in
  let open Cohttp_lwt_unix in

  Client.post
    (Uri.of_string url)
    ~body:(Cohttp_lwt.Body.of_string bytes)
    ~headers:(Cohttp.Header.of_list
      [ "Accept", "application/protobuf"
      ; "Content-Type", "application/protobuf"
      ; "Twirp-Version", "v5.4.2"
      ]
    ) >>= fun (resp, body) ->
  Format.printf "%a\n\n" Cohttp.Response.pp_hum resp;
  Body.to_string body >>= fun content ->

  if response_is_success resp
  then Lwt_result.return content
  else Lwt_result.fail @@ Twirp_Error content

let do_protobuf_enc_dec url enc dec src =
  let encoder = Pbrt.Encoder.create () in
  enc src encoder;

  do_protobuf_request url
    (Pbrt.Encoder.to_bytes encoder)
  |> Lwt_result.map (fun body ->
      print_endline body;
      (Pbrt.Decoder.of_bytes >>> dec) body
    )


open Service_types

let path_prefix = "/twirp/twirp.example.haberdasher.Haberdasher/"

module Client = struct
  type t = { host : string }

  let create host =
    { host }

  (*
  let make_hat2 {host} (s:size) =
    let encoder = Pbrt.Encoder.create () in
    Service_pb.encode_size s encoder;

    do_protobuf_request
      (host ^ path_prefix ^ "MakeHat")
      (Pbrt.Encoder.to_bytes encoder)
    |> Lwt.map Pbrt.Decoder.of_bytes
    |> Lwt.map Service_pb.decode_hat
     *)

  let make_hat {host} (s:size) =
    Lwt_result.get_exn @@
    do_protobuf_enc_dec
      (host ^ path_prefix ^ "MakeHat")
      Service_pb.encode_size
      Service_pb.decode_hat
      s
end


let () =
  let c = Client.create "http://localhost:8080" in
  let hat = Client.make_hat c (default_size ~inches:20l ()) in
  let run = Lwt.map (fun h -> 
      Printf.printf "%s, %s : %ld\n" h.name h.color h.inches
    ) hat
  in

  Lwt_main.run run
