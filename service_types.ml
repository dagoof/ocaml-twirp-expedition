[@@@ocaml.warning "-27-30-39"]


type size = {
  inches : int32;
}

type hat = {
  inches : int32;
  color : string;
  name : string;
}

let rec default_size 
  ?inches:((inches:int32) = 0l)
  () : size  = {
  inches;
}

let rec default_hat 
  ?inches:((inches:int32) = 0l)
  ?color:((color:string) = "")
  ?name:((name:string) = "")
  () : hat  = {
  inches;
  color;
  name;
}
