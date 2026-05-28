module type IBUILD = sig
  (* To be instanciated *)
  module M : Util.Monad.MONAD

  type conf

  val interactive_build :
    show_move:(string -> unit) ->
    show_conf:(Yojson.Safe.t -> unit) ->
    show_moves_list:(Yojson.Safe.t list -> unit) ->
    (* the argument of get_move is the 
    number of moves *)
    get_move:(int -> int M.m) ->
    conf ->
    unit M.m
end

(* This module type is used by interactive_build to signify that it accepts any
   LTS, provided that the LTS is capable of resolving non-determinism by itself *)
module type RUN_LTS = sig
  include Strategy.LTS

  module M : Util.Monad.MONAD

  val choose : (TypingLTS.Moves.pol_move * passive_conf) EvalMonad.m -> (TypingLTS.Moves.pol_move * passive_conf) EvalMonad.result M.m
end

module Make : functor (M : Util.Monad.MONAD) (IntLTS : RUN_LTS with module M = M) ->
  IBUILD with module M = M and type conf = IntLTS.conf
