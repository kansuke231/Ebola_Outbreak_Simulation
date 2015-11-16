(* THIS FILE IS GENERATED. *)
(* rmlc -dtypes -n -1 -sampling -1.0 ebola_outbreak.rml  *)

open Implem_lco_ctrl_tree_record;;
type  status
= Susceptible |  Exposed |  Infectious |  Removed ;;
type  dir
=
  Up | 
  Down | 
  Left | 
  Right |  Up_Left |  Up_Right |  Down_Left |  Down_Right |  Long_Lange ;;
let opposite =
      (function
        | dir__val_rml_2  ->
            (match dir__val_rml_2 with | Up  -> Down | Down  -> Up
             | Left  -> Right | Right  -> Left | Up_Left  -> Down_Right
             | Up_Right  -> Down_Left | Down_Left  -> Up_Right
             | Down_Right  -> Up_Left | Long_Lange  -> Long_Lange )
        ) 
;;
type 'a info
= {  origin: dir ;   status: status} ;;
type 'a neighborhood
= (('a) info) list ;;
let maxx = Pervasives.ref 300 
;;
let maxy = Pervasives.ref 300 
;;
let nox = Pervasives.ref false 
;;
let zoom = Pervasives.ref 2 
;;
let delta = 3 
;;
let gamma = 15 
;;
type 'a cell
= {
   cell_x: int ; 
   cell_y: int ; 
   cell_activation: (('a) info, (('a) info) list) Lco_ctrl_tree_record.event
  ; 
  mutable cell_status: status ; 
  mutable cell_neighborhood:
  ((dir * (('a) info, (('a) info) list) Lco_ctrl_tree_record.event)) list ; 
  mutable time: int ; 
  mutable exposed_time: int ;  mutable infectious_time: int} ;;
let make_info =
      (function
        | origin__val_rml_10  ->
            (function
              | cell__val_rml_11  ->
                  {origin=(origin__val_rml_10);
                   status=(cell__val_rml_11).cell_status}
              )
        ) 
;;
let new_cell =
      (function
        | x__val_rml_13  ->
            (function
              | y__val_rml_14  ->
                  (function
                    | activation__val_rml_15  ->
                        (function
                          | status__val_rml_16  ->
                              {cell_x=(x__val_rml_13);
                               cell_y=(y__val_rml_14);
                               cell_activation=(activation__val_rml_15);
                               cell_status=(status__val_rml_16);
                               cell_neighborhood=(([]));
                               time=((0));
                               exposed_time=((0)); infectious_time=((0))}
                          )
                    )
              )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_18  ->
            (function
              | c__val_rml_19  ->
                  Graphics.set_color
                    (color_of_cell__val_rml_18 c__val_rml_19);
                    Graphics.fill_rect
                      (Pervasives.( * )
                        (c__val_rml_19).cell_x (Pervasives.(!) zoom))
                      (Pervasives.( * )
                        (c__val_rml_19).cell_y (Pervasives.(!) zoom))
                      (Pervasives.(!) zoom) (Pervasives.(!) zoom)
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_21  ->
            (match (s__val_rml_21).cell_status with
             | Susceptible  -> Graphics.blue | Exposed  -> Graphics.green
             | Infectious  -> Graphics.red | Removed  -> Graphics.white )
        ) 
;;
let get_von_neumann_neighbors =
      (function
        | cell__val_rml_23  ->
            (function
              | cell_array__val_rml_24  ->
                  (let x__val_rml_25 = (cell__val_rml_23).cell_x  in
                    let y__val_rml_26 = (cell__val_rml_23).cell_y  in
                      let neighbors__val_rml_27 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_25 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_27
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_24
                                  (Pervasives.(-) x__val_rml_25 1))
                                y__val_rml_26))
                              :: (Pervasives.(!) neighbors__val_rml_27))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_25 1)
                              (Pervasives.(!) maxx)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_27
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_24
                                    (Pervasives.(+) x__val_rml_25 1))
                                  y__val_rml_26))
                                :: (Pervasives.(!) neighbors__val_rml_27))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_26 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_27
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_24 x__val_rml_25)
                                  (Pervasives.(-) y__val_rml_26 1)))
                                :: (Pervasives.(!) neighbors__val_rml_27))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_26 1)
                              (Pervasives.(!) maxy)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_27
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_24 x__val_rml_25)
                                  (Pervasives.(+) y__val_rml_26 1)))
                                :: (Pervasives.(!) neighbors__val_rml_27))
                            else ();
                          Pervasives.(!) neighbors__val_rml_27)
              )
        ) 
;;
let rec activate_neighborhood =
          (function
            | self__val_rml_29  ->
                (function
                  | neighbors__val_rml_30  ->
                      (match neighbors__val_rml_30 with | ([])  -> ()
                       | ((dir__val_rml_31, activation_sig__val_rml_32)) ::
                           (neighbors__val_rml_33)  ->
                           (let info__val_rml_34 =
                                  make_info
                                    (opposite dir__val_rml_31)
                                    self__val_rml_29
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               activation_sig__val_rml_32 info__val_rml_34;
                               activate_neighborhood
                                 self__val_rml_29 neighbors__val_rml_33)
                       )
                  )
            ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_36  ->
                (function
                  | cell_array__val_rml_37  ->
                      (let maxx__val_rml_38 = Pervasives.(!) maxx  in
                        let maxy__val_rml_39 = Pervasives.(!) maxy  in
                          let x__val_rml_40 = (cell__val_rml_36).cell_x  in
                            let y__val_rml_41 = (cell__val_rml_36).cell_y  in
                              let rand_x__val_rml_42 =
                                    Random.int maxx__val_rml_38
                                 in
                                let rand_y__val_rml_43 =
                                      Random.int maxy__val_rml_39
                                   in
                                  if
                                    Pervasives.(&&)
                                      (Pervasives.(<>)
                                        x__val_rml_40 rand_x__val_rml_42)
                                      (Pervasives.(<>)
                                        y__val_rml_41 rand_y__val_rml_43)
                                    then
                                    (Long_Lange,
                                     (Array.get
                                       (Array.get
                                         cell_array__val_rml_37
                                         rand_x__val_rml_42)
                                       rand_y__val_rml_43))
                                    else
                                    long_range_interaction
                                      cell__val_rml_36 cell_array__val_rml_37)
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_45  ->
            (function
              | get_neighbors__val_rml_46  ->
                  (function
                    | cell_behavior__val_rml_47  ->
                        (function
                          | x__val_rml_48  ->
                              (function
                                | y__val_rml_49  ->
                                    (function
                                      | status_init__val_rml_50  ->
                                          (function
                                            | cell_array__val_rml_51  ->
                                                ((function
                                                   | ()  ->
                                                       Lco_ctrl_tree_record.rml_signal
                                                         (function
                                                           | activation__sig_52
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    new_cell
                                                                    x__val_rml_48
                                                                    y__val_rml_49
                                                                    activation__sig_52
                                                                    status_init__val_rml_50
                                                                   )
                                                                 (function
                                                                   | 
                                                                   self__val_rml_53
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_51
                                                                    x__val_rml_48)
                                                                    y__val_rml_49
                                                                    activation__sig_52;
                                                                    draw_cell__val_rml_45
                                                                    self__val_rml_53
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_53.cell_neighborhood
                                                                    <-
                                                                    get_neighbors__val_rml_46
                                                                    self__val_rml_53
                                                                    cell_array__val_rml_51
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    long_range_interaction
                                                                    self__val_rml_53
                                                                    cell_array__val_rml_51
                                                                    )
                                                                    (function
                                                                    | faraway__val_rml_54
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    activate_neighborhood
                                                                    self__val_rml_53
                                                                    (Pervasives.(@)
                                                                    (self__val_rml_53).cell_neighborhood
                                                                    (faraway__val_rml_54
                                                                    :: 
                                                                    ([]))) ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    (let 
                                                                    neighbors__val_rml_55
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_52
                                                                     in
                                                                    cell_behavior__val_rml_47
                                                                    self__val_rml_53
                                                                    neighbors__val_rml_55;
                                                                    draw_cell__val_rml_45
                                                                    self__val_rml_53;
                                                                    self__val_rml_53.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_53).time
                                                                    1) )) )))
                                                                   )
                                                           )
                                                   ):
                                                  (_)
                                                    Lco_ctrl_tree_record.process)
                                            )
                                      )
                                )
                          )
                    )
              )
        ) 
;;
let ebola =
      (function
        | cell__val_rml_57  ->
            (function
              | neighbors__val_rml_58  ->
                  (let result__val_rml_59 = Pervasives.ref Susceptible  in
                    List.iter
                      (function
                        | info__val_rml_60  ->
                            if
                              Pervasives.(&&)
                                (Pervasives.(=)
                                  (info__val_rml_60).status Infectious)
                                (Pervasives.(<) (Random.float 1.) 0.1)
                              then Pervasives.(:=) result__val_rml_59 Exposed
                              else ()
                        )
                      neighbors__val_rml_58;
                      cell__val_rml_57.cell_status <-
                        (match (cell__val_rml_57).cell_status with
                         | Susceptible  ->
                             if
                               Pervasives.(=)
                                 (Pervasives.(!) result__val_rml_59) Exposed
                               then
                               (cell__val_rml_57.exposed_time <-
                                  (cell__val_rml_57).time;
                                 Exposed)
                               else Susceptible
                         | Exposed  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_57).time
                                   (cell__val_rml_57).exposed_time)
                                 delta
                               then Exposed else
                               (cell__val_rml_57.infectious_time <-
                                  (cell__val_rml_57).time;
                                 Infectious)
                         | Infectious  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_57).time
                                   (cell__val_rml_57).infectious_time)
                                 gamma
                               then Infectious else Removed
                         | Removed  -> Removed ))
              )
        ) 
;;
let cell_array_create =
      (function
        | tmp__val_rml_62  ->
            Array.make_matrix
              (Pervasives.(!) maxx) (Pervasives.(!) maxy) tmp__val_rml_62
        ) 
;;
let get_status =
      (function
        | i__val_rml_64  ->
            (function
              | j__val_rml_65  ->
                  if Pervasives.(<) (Random.float 1.) 0.015 then Infectious
                    else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_67  ->
            (function
              | get_neighbors__val_rml_68  ->
                  (function
                    | get_status__val_rml_69  ->
                        (function
                          | cell_behavior__val_rml_70  ->
                              (function
                                | cell_array__val_rml_71  ->
                                    ((function
                                       | ()  ->
                                           Lco_ctrl_tree_record.rml_fordopar
                                             (function | ()  -> (0) )
                                             (function
                                               | ()  ->
                                                   Pervasives.(-)
                                                     (Pervasives.(!) maxx) 1
                                               )
                                             true
                                             (function
                                               | i__val_rml_72  ->
                                                   Lco_ctrl_tree_record.rml_fordopar
                                                     (function | ()  -> (0) )
                                                     (function
                                                       | ()  ->
                                                           Pervasives.(-)
                                                             (Pervasives.(!)
                                                               maxy)
                                                             1
                                                       )
                                                     true
                                                     (function
                                                       | j__val_rml_73  ->
                                                           Lco_ctrl_tree_record.rml_run
                                                             (function
                                                               | ()  ->
                                                                   cell
                                                                    draw_cell__val_rml_67
                                                                    get_neighbors__val_rml_68
                                                                    cell_behavior__val_rml_70
                                                                    i__val_rml_72
                                                                    j__val_rml_73
                                                                    (get_status__val_rml_69
                                                                    i__val_rml_72
                                                                    j__val_rml_73)
                                                                    cell_array__val_rml_71
                                                               )
                                                       )
                                               )
                                       ):
                                      (_) Lco_ctrl_tree_record.process)
                                )
                          )
                    )
              )
        ) 
;;
let main =
      ((function
         | ()  ->
             Lco_ctrl_tree_record.rml_seq
               (Lco_ctrl_tree_record.rml_compute
                 (function
                   | ()  ->
                       Random.self_init ();
                         Graphics.open_graph
                           (Pervasives.(^)
                             " "
                             (Pervasives.(^)
                               (Pervasives.string_of_int
                                 (Pervasives.( * )
                                   (Pervasives.(!) maxx)
                                   (Pervasives.(!) zoom)))
                               (Pervasives.(^)
                                 "x"
                                 (Pervasives.string_of_int
                                   (Pervasives.( * )
                                     (Pervasives.(!) maxy)
                                     (Pervasives.(!) zoom))))));
                         Graphics.auto_synchronize false
                   ))
               (Lco_ctrl_tree_record.rml_signal
                 (function
                   | tmp__sig_75  ->
                       Lco_ctrl_tree_record.rml_def
                         (function | ()  -> cell_array_create tmp__sig_75 )
                         (function
                           | cell_array__val_rml_76  ->
                               Lco_ctrl_tree_record.rml_def
                                 (function
                                   | ()  -> draw_cell_gen color_of_status )
                                 (function
                                   | draw__val_rml_77  ->
                                       Lco_ctrl_tree_record.rml_par
                                         (Lco_ctrl_tree_record.rml_run
                                           (function
                                             | ()  ->
                                                 cellular_automaton_start
                                                   draw__val_rml_77
                                                   get_von_neumann_neighbors
                                                   get_status
                                                   ebola
                                                   cell_array__val_rml_76
                                             ))
                                         (Lco_ctrl_tree_record.rml_loop
                                           (Lco_ctrl_tree_record.rml_seq
                                             (Lco_ctrl_tree_record.rml_compute
                                               (function
                                                 | ()  ->
                                                     Pervasives.ignore
                                                       (Graphics.wait_next_event
                                                         (Graphics.Poll ::
                                                           ([])));
                                                       Graphics.synchronize
                                                         ()
                                                 ))
                                             Lco_ctrl_tree_record.rml_pause))
                                   )
                           )
                   ))
         ):
        (_) Lco_ctrl_tree_record.process) 
;;
let () =
      Rml_machine.rml_exec
        ([])
        ((function
           | ()  -> Lco_ctrl_tree_record.rml_run (function | ()  -> main ) ):
          (_) Lco_ctrl_tree_record.process) 
;;
