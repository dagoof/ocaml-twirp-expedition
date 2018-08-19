(** service.proto Types *)



(** {2 Types} *)

type size = {
  inches : int32;
}

type hat = {
  inches : int32;
  color : string;
  name : string;
}


(** {2 Default values} *)

val default_size : 
  ?inches:int32 ->
  unit ->
  size
(** [default_size ()] is the default value for type [size] *)

val default_hat : 
  ?inches:int32 ->
  ?color:string ->
  ?name:string ->
  unit ->
  hat
(** [default_hat ()] is the default value for type [hat] *)
