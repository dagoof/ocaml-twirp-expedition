(** service.proto Binary Encoding *)


(** {2 Protobuf Encoding} *)

val encode_size : Service_types.size -> Pbrt.Encoder.t -> unit
(** [encode_size v encoder] encodes [v] with the given [encoder] *)

val encode_hat : Service_types.hat -> Pbrt.Encoder.t -> unit
(** [encode_hat v encoder] encodes [v] with the given [encoder] *)


(** {2 Protobuf Decoding} *)

val decode_size : Pbrt.Decoder.t -> Service_types.size
(** [decode_size decoder] decodes a [size] value from [decoder] *)

val decode_hat : Pbrt.Decoder.t -> Service_types.hat
(** [decode_hat decoder] decodes a [hat] value from [decoder] *)
