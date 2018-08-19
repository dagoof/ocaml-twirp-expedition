[@@@ocaml.warning "-27-30-39"]

type size_mutable = {
  mutable inches : int32;
}

let default_size_mutable () : size_mutable = {
  inches = 0l;
}

type hat_mutable = {
  mutable inches : int32;
  mutable color : string;
  mutable name : string;
}

let default_hat_mutable () : hat_mutable = {
  inches = 0l;
  color = "";
  name = "";
}


let rec decode_size d =
  let v = default_size_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.inches <- Pbrt.Decoder.int32_as_varint d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(size), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Service_types.inches = v.inches;
  } : Service_types.size)

let rec decode_hat d =
  let v = default_hat_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.inches <- Pbrt.Decoder.int32_as_varint d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(hat), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.color <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(hat), field(2)" pk
    | Some (3, Pbrt.Bytes) -> begin
      v.name <- Pbrt.Decoder.string d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(hat), field(3)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Service_types.inches = v.inches;
    Service_types.color = v.color;
    Service_types.name = v.name;
  } : Service_types.hat)

let rec encode_size (v:Service_types.size) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int32_as_varint v.Service_types.inches encoder;
  ()

let rec encode_hat (v:Service_types.hat) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int32_as_varint v.Service_types.inches encoder;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Service_types.color encoder;
  Pbrt.Encoder.key (3, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Service_types.name encoder;
  ()
