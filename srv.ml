exception Twirp_Error of string

let (>>>) f g x = g @@ f x

open Service_types

let path_prefix = "/twirp/twirp.example.haberdasher.Haberdasher"

module TwirpServer = struct
  let make_hat (size:size) =
    if size.inches <= 0l
    then Lwt_result.fail @@ Twirp_Error "I cant make a hat that small"
    else Lwt_result.return
        { inches = size.inches
        ; color  = "red"
        ; name   = "football cap"
        }
end

open Lwt
open Cohttp
open Cohttp_lwt_unix

let handle_request decoder encoder handler body =
  Cohttp_lwt.Body.to_string body >>= fun content ->
  let result =
    handler @@ decoder @@ Pbrt.Decoder.of_bytes content
  in

  Lwt_result.get_exn @@
  Lwt_result.map (fun r ->
      let e = Pbrt.Encoder.create () in

      encoder r e;
      Pbrt.Encoder.to_bytes e
    ) result


let server =
  let callback _conn req body =
    match Uri.path @@ Request.uri req, Request.meth req with
    | "/twirp/twirp.example.haberdasher.Haberdasher/MakeHat", `POST ->
      let result =
        handle_request
          Service_pb.decode_size
          Service_pb.encode_hat
          TwirpServer.make_hat
          body
      in
      result >>= fun content ->
      Server.respond_string ~status:`OK ~body:content ()

    | "/twirp/twirp.example.haberdasher.Haberdasher/MakeHat", _ ->
      Server.respond_string ~status:`OK ~body:path_prefix ()

    | path, meth ->
      let uri = req |> Request.uri |> Uri.to_string in
      let meth = meth |> Code.string_of_method in
      let headers = req |> Request.headers |> Header.to_string in
      body |> Cohttp_lwt.Body.to_string >|= (fun body ->
          (Printf.sprintf "Uri: %s\nPath: %s\nMethod: %s\nHeaders\nHeaders: %s\nBody: %s"
             uri path meth headers body))
      >>= (fun body -> Server.respond_string ~status:`OK ~body ())
  in
  Server.create ~mode:(`TCP (`Port 8000)) (Server.make ~callback ())

let () = ignore (Lwt_main.run server)
