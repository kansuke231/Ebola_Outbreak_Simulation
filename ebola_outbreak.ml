(* THIS FILE IS GENERATED. *)
(* rmlc -dtypes -n -1 -sampling -1.0 ebola_outbreak.rml  *)

open Implem_lco_ctrl_tree_record;;
type  status
= Susceptible |  Exposed |  Infectious |  Removed ;;
type  sector_status
= A |  B |  C ;;
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
let sectormaxx = Pervasives.ref 10 
;;
let sectormaxy = Pervasives.ref 10 
;;
let sectorsize =
      Pervasives.ref
        (Pervasives.(/) (Pervasives.(!) maxx) (Pervasives.(!) sectormaxx)) 
;;
let nox = Pervasives.ref false 
;;
let zoom = Pervasives.ref 3 
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
   compliant: bool ; 
  mutable cell_status: status ; 
  mutable cell_neighborhood: ((dir * ('a) cell)) list ; 
  mutable time: int ; 
  mutable exposed_time: int ;  mutable infectious_time: int} ;;
let make_info =
      (function
        | origin__val_rml_13  ->
            (function
              | cell__val_rml_14  ->
                  {origin=(origin__val_rml_13);
                   status=(cell__val_rml_14).cell_status}
              )
        ) 
;;
let new_cell =
      (function
        | x__val_rml_16  ->
            (function
              | y__val_rml_17  ->
                  (function
                    | activation__val_rml_18  ->
                        (function
                          | status__val_rml_19  ->
                              {cell_x=(x__val_rml_16);
                               cell_y=(y__val_rml_17);
                               cell_activation=(activation__val_rml_18);
                               cell_status=(status__val_rml_19);
                               cell_neighborhood=(([]));
                               time=((0));
                               exposed_time=((0));
                               infectious_time=((0));
                               compliant=(if
                                           Pervasives.(<)
                                             (Random.float 1.) 0.4
                                           then true else false)}
                          )
                    )
              )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_21  ->
            (function
              | c__val_rml_22  ->
                  Graphics.set_color
                    (color_of_cell__val_rml_21 c__val_rml_22);
                    Graphics.fill_rect
                      (Pervasives.( * )
                        (c__val_rml_22).cell_x (Pervasives.(!) zoom))
                      (Pervasives.( * )
                        (c__val_rml_22).cell_y (Pervasives.(!) zoom))
                      (Pervasives.(!) zoom) (Pervasives.(!) zoom)
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_24  ->
            (match (s__val_rml_24).cell_status with
             | Susceptible  -> Graphics.blue | Exposed  -> Graphics.green
             | Infectious  -> Graphics.red | Removed  -> Graphics.white )
        ) 
;;
let get_von_neumann_neighbors =
      (function
        | cell__val_rml_26  ->
            (function
              | cell_array__val_rml_27  ->
                  (let x__val_rml_28 = (cell__val_rml_26).cell_x  in
                    let y__val_rml_29 = (cell__val_rml_26).cell_y  in
                      let neighbors__val_rml_30 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_28 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_30
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_27
                                  (Pervasives.(-) x__val_rml_28 1))
                                y__val_rml_29))
                              :: (Pervasives.(!) neighbors__val_rml_30))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_28 1)
                              (Pervasives.(!) maxx)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_30
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_27
                                    (Pervasives.(+) x__val_rml_28 1))
                                  y__val_rml_29))
                                :: (Pervasives.(!) neighbors__val_rml_30))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_29 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_30
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_27 x__val_rml_28)
                                  (Pervasives.(-) y__val_rml_29 1)))
                                :: (Pervasives.(!) neighbors__val_rml_30))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_29 1)
                              (Pervasives.(!) maxy)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_30
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_27 x__val_rml_28)
                                  (Pervasives.(+) y__val_rml_29 1)))
                                :: (Pervasives.(!) neighbors__val_rml_30))
                            else ();
                          Pervasives.(!) neighbors__val_rml_30)
              )
        ) 
;;
let rec activate_neighborhood =
          (function
            | self__val_rml_32  ->
                (function
                  | neighbors__val_rml_33  ->
                      (match neighbors__val_rml_33 with | ([])  -> ()
                       | ((dir__val_rml_34, cell__val_rml_35)) ::
                           (neighbors'__val_rml_36)  ->
                           (let info__val_rml_37 =
                                  make_info
                                    (opposite dir__val_rml_34)
                                    self__val_rml_32
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (cell__val_rml_35).cell_activation
                               info__val_rml_37;
                               activate_neighborhood
                                 self__val_rml_32 neighbors'__val_rml_36)
                       )
                  )
            ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_39  ->
                (function
                  | cell_array__val_rml_40  ->
                      (let maxx__val_rml_41 = Pervasives.(!) maxx  in
                        let maxy__val_rml_42 = Pervasives.(!) maxy  in
                          let x__val_rml_43 = (cell__val_rml_39).cell_x  in
                            let y__val_rml_44 = (cell__val_rml_39).cell_y  in
                              let rand_x__val_rml_45 =
                                    Random.int maxx__val_rml_41
                                 in
                                let rand_y__val_rml_46 =
                                      Random.int maxy__val_rml_42
                                   in
                                  if
                                    Pervasives.(&&)
                                      (Pervasives.(<>)
                                        x__val_rml_43 rand_x__val_rml_45)
                                      (Pervasives.(<>)
                                        y__val_rml_44 rand_y__val_rml_46)
                                    then
                                    (let other__val_rml_47 =
                                           Array.get
                                             (Array.get
                                               cell_array__val_rml_40
                                               rand_x__val_rml_45)
                                             rand_y__val_rml_46
                                       in
                                      let other_activation__val_rml_48 =
                                            (other__val_rml_47).cell_activation
                                         in
                                        Lco_ctrl_tree_record.rml_expr_emit_val
                                          (cell__val_rml_39).cell_activation
                                          (make_info
                                            Long_Lange other__val_rml_47);
                                          Lco_ctrl_tree_record.rml_expr_emit_val
                                            other_activation__val_rml_48
                                            (make_info
                                              Long_Lange cell__val_rml_39))
                                    else
                                    long_range_interaction
                                      cell__val_rml_39 cell_array__val_rml_40)
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_50  ->
            (function
              | get_neighbors__val_rml_51  ->
                  (function
                    | cell_behavior__val_rml_52  ->
                        (function
                          | x__val_rml_53  ->
                              (function
                                | y__val_rml_54  ->
                                    (function
                                      | status_init__val_rml_55  ->
                                          (function
                                            | cell_array__val_rml_56  ->
                                                ((function
                                                   | ()  ->
                                                       Lco_ctrl_tree_record.rml_signal
                                                         (function
                                                           | activation__sig_57
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    new_cell
                                                                    x__val_rml_53
                                                                    y__val_rml_54
                                                                    activation__sig_57
                                                                    status_init__val_rml_55
                                                                   )
                                                                 (function
                                                                   | 
                                                                   self__val_rml_58
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_56
                                                                    x__val_rml_53)
                                                                    y__val_rml_54
                                                                    self__val_rml_58;
                                                                    draw_cell__val_rml_50
                                                                    self__val_rml_58
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_58.cell_neighborhood
                                                                    <-
                                                                    get_neighbors__val_rml_51
                                                                    self__val_rml_58
                                                                    cell_array__val_rml_56
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    long_range_interaction
                                                                    self__val_rml_58
                                                                    cell_array__val_rml_56
                                                                    )
                                                                    (function
                                                                    | faraway__val_rml_59
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    activate_neighborhood
                                                                    self__val_rml_58
                                                                    (self__val_rml_58).cell_neighborhood
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    (let 
                                                                    neighbors__val_rml_60
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_57
                                                                     in
                                                                    cell_behavior__val_rml_52
                                                                    self__val_rml_58
                                                                    neighbors__val_rml_60;
                                                                    draw_cell__val_rml_50
                                                                    self__val_rml_58;
                                                                    self__val_rml_58.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_58).time
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
        | cell__val_rml_62  ->
            (function
              | neighbors__val_rml_63  ->
                  (let result__val_rml_64 = Pervasives.ref Susceptible  in
                    List.iter
                      (function
                        | info__val_rml_65  ->
                            (match info__val_rml_65 with
                             | {origin=Long_Lange; status=Infectious}  ->
                                 if Pervasives.(<) (Random.float 1.) 0.04
                                   then
                                   Pervasives.(:=) result__val_rml_64 Exposed
                                   else ()
                             | {origin=_; status=Infectious}  ->
                                 if Pervasives.(<) (Random.float 1.) 0.1 then
                                   Pervasives.(:=) result__val_rml_64 Exposed
                                   else ()
                             | {origin=_; status=_}  -> () )
                        )
                      neighbors__val_rml_63;
                      cell__val_rml_62.cell_status <-
                        (match (cell__val_rml_62).cell_status with
                         | Susceptible  ->
                             if
                               Pervasives.(=)
                                 (Pervasives.(!) result__val_rml_64) Exposed
                               then
                               (cell__val_rml_62.exposed_time <-
                                  (cell__val_rml_62).time;
                                 Exposed)
                               else Susceptible
                         | Exposed  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_62).time
                                   (cell__val_rml_62).exposed_time)
                                 delta
                               then Exposed else
                               (cell__val_rml_62.infectious_time <-
                                  (cell__val_rml_62).time;
                                 Infectious)
                         | Infectious  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_62).time
                                   (cell__val_rml_62).infectious_time)
                                 gamma
                               then Infectious else Removed
                         | Removed  -> Removed ))
              )
        ) 
;;
let cell_array_create =
      (function
        | tmp__val_rml_67  ->
            Array.make_matrix
              (Pervasives.(!) maxx) (Pervasives.(!) maxy) tmp__val_rml_67
        ) 
;;
let sector_array_create =
      (function
        | tmp__val_rml_69  ->
            Array.make_matrix
              (Pervasives.(!) sectormaxx)
              (Pervasives.(!) sectormaxy) tmp__val_rml_69
        ) 
;;
let get_status =
      (function
        | i__val_rml_71  ->
            (function
              | j__val_rml_72  ->
                  if Pervasives.(<) (Random.float 1.) 0.0005 then Infectious
                    else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_74  ->
            (function
              | get_neighbors__val_rml_75  ->
                  (function
                    | get_status__val_rml_76  ->
                        (function
                          | cell_behavior__val_rml_77  ->
                              (function
                                | cell_array__val_rml_78  ->
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
                                               | i__val_rml_79  ->
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
                                                       | j__val_rml_80  ->
                                                           Lco_ctrl_tree_record.rml_run
                                                             (function
                                                               | ()  ->
                                                                   cell
                                                                    draw_cell__val_rml_74
                                                                    get_neighbors__val_rml_75
                                                                    cell_behavior__val_rml_77
                                                                    i__val_rml_79
                                                                    j__val_rml_80
                                                                    (get_status__val_rml_76
                                                                    i__val_rml_79
                                                                    j__val_rml_80)
                                                                    cell_array__val_rml_78
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
                   | tmp__sig_82  ->
                       Lco_ctrl_tree_record.rml_def
                         (function
                           | ()  -> new_cell 5 5 tmp__sig_82 Susceptible )
                         (function
                           | dummy__val_rml_83  ->
                               Lco_ctrl_tree_record.rml_def
                                 (function
                                   | ()  ->
                                       cell_array_create dummy__val_rml_83
                                   )
                                 (function
                                   | cell_array__val_rml_84  ->
                                       Lco_ctrl_tree_record.rml_def
                                         (function
                                           | ()  ->
                                               draw_cell_gen color_of_status
                                           )
                                         (function
                                           | draw__val_rml_85  ->
                                               Lco_ctrl_tree_record.rml_par
                                                 (Lco_ctrl_tree_record.rml_run
                                                   (function
                                                     | ()  ->
                                                         cellular_automaton_start
                                                           draw__val_rml_85
                                                           get_von_neumann_neighbors
                                                           get_status
                                                           ebola
                                                           cell_array__val_rml_84
                                                     ))
                                                 (Lco_ctrl_tree_record.rml_loop
                                                   (Lco_ctrl_tree_record.rml_seq
                                                     (Lco_ctrl_tree_record.rml_compute
                                                       (function
                                                         | ()  ->
                                                             Pervasives.ignore
                                                               (Graphics.wait_next_event
                                                                 (Graphics.Poll
                                                                   :: 
                                                                   ([])));
                                                               Graphics.synchronize
                                                                 ()
                                                         ))
                                                     Lco_ctrl_tree_record.rml_pause))
                                           )
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
