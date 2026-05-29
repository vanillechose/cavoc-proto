module Make (BranchMonad : Util.Monad.BRANCH) = struct
  include Store
  module BranchMonad = BranchMonad


  let generate_store (loc_ctx, symbolic_ctx, cons_ctx) =
    Util.Debug.print_debug @@ "Generating store for "
    ^ Type_ctx.string_of_loc_ctx loc_ctx;
    let open BranchMonad in
    let symbolic_ctx = { Symbolic.empty with pathdecl = symbolic_ctx } in
    let* heap = BranchMonad.para_list @@ Heap.generate_heaps loc_ctx in
    return { empty_store with heap ; symbolic_ctx ; cons_ctx }
end
