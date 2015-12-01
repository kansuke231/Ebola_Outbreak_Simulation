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
type  info
= {  origin: dir ;   status: status ;   sector: (int * int)} ;;
type  neighborhood
= (info) list ;;
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
type  cell
= {
   cell_x: int ; 
   cell_y: int ; 
   cell_activation: (info, (info) list) Lco_ctrl_tree_record.event ; 
   compliant: bool ; 
  mutable cell_status: status ; 
  mutable cell_neighborhood: ((dir * cell)) list ; 
  mutable time: int ; 
  mutable exposed_time: int ; 
  mutable infectious_time: int ;  mutable sector_id: (int * int)} ;;
let make_info =
      (function
        | origin__val_rml_13  ->
            (function
              | cell__val_rml_14  ->
                  {origin=(origin__val_rml_13);
                   status=(cell__val_rml_14).cell_status;
                   sector=(cell__val_rml_14).sector_id}
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
                              (function
                                | sector_id__val_rml_20  ->
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
                                                 then true else false);
                                     sector_id=(sector_id__val_rml_20)}
                                )
                          )
                    )
              )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_22  ->
            (function
              | c__val_rml_23  ->
                  Graphics.set_color
                    (color_of_cell__val_rml_22 c__val_rml_23);
                    Graphics.fill_rect
                      (Pervasives.( * )
                        (c__val_rml_23).cell_x (Pervasives.(!) zoom))
                      (Pervasives.( * )
                        (c__val_rml_23).cell_y (Pervasives.(!) zoom))
                      (Pervasives.(!) zoom) (Pervasives.(!) zoom);
                    if
                      Pervasives.(=)
                        (Pervasives.(mod)
                          (c__val_rml_23).cell_x (Pervasives.(!) sectormaxx))
                        (0)
                      then
                      (Graphics.set_color Graphics.black;
                         Graphics.moveto
                           (Pervasives.( * )
                             (c__val_rml_23).cell_x (Pervasives.(!) zoom))
                           (Pervasives.( * )
                             (c__val_rml_23).cell_y (Pervasives.(!) zoom));
                        Graphics.lineto
                          (Pervasives.( * )
                            (c__val_rml_23).cell_x (Pervasives.(!) zoom))
                          (Pervasives.( * )
                            (Pervasives.(+) (c__val_rml_23).cell_y 1)
                            (Pervasives.(!) zoom)))
                      else
                      if
                        Pervasives.(=)
                          (Pervasives.(mod)
                            (c__val_rml_23).cell_y
                            (Pervasives.(!) sectormaxy))
                          (0)
                        then
                        (Graphics.set_color Graphics.black;
                           Graphics.moveto
                             (Pervasives.( * )
                               (c__val_rml_23).cell_x (Pervasives.(!) zoom))
                             (Pervasives.( * )
                               (c__val_rml_23).cell_y (Pervasives.(!) zoom));
                          Graphics.lineto
                            (Pervasives.( * )
                              (Pervasives.(+) (c__val_rml_23).cell_x 1)
                              (Pervasives.(!) zoom))
                            (Pervasives.( * )
                              (c__val_rml_23).cell_y (Pervasives.(!) zoom)))
                        else ()
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_25  ->
            (match (s__val_rml_25).cell_status with
             | Susceptible  -> Graphics.blue | Exposed  -> Graphics.green
             | Infectious  -> Graphics.red | Removed  -> Graphics.white )
        ) 
;;
type 'a sector
= {
  mutable sector_status: sector_status ; 
   sector_activation: (status, (status) list) Lco_ctrl_tree_record.event ;  
  coordinate: (int * int)} ;;
let new_sector =
      (function
        | status__val_rml_27  ->
            (function
              | activation__val_rml_28  ->
                  (function
                    | coordinate__val_rml_29  ->
                        {sector_status=(status__val_rml_27);
                         sector_activation=(activation__val_rml_28);
                         coordinate=(coordinate__val_rml_29)}
                    )
              )
        ) 
;;
let sector =
      (function
        | coordinate__val_rml_31  ->
            (function
              | sector_array__val_rml_32  ->
                  ((function
                     | ()  ->
                         Lco_ctrl_tree_record.rml_signal
                           (function
                             | sector_activation__sig_33  ->
                                 (let (x__val_rml_34, y__val_rml_35) =
                                        coordinate__val_rml_31
                                    in
                                   Lco_ctrl_tree_record.rml_def
                                     (function
                                       | ()  ->
                                           new_sector
                                             A
                                             sector_activation__sig_33
                                             coordinate__val_rml_31
                                       )
                                     (function
                                       | self_sector__val_rml_36  ->
                                           Lco_ctrl_tree_record.rml_seq
                                             (Lco_ctrl_tree_record.rml_seq
                                               (Lco_ctrl_tree_record.rml_compute
                                                 (function
                                                   | ()  ->
                                                       Array.set
                                                         (Array.get
                                                           sector_array__val_rml_32
                                                           x__val_rml_34)
                                                         y__val_rml_35
                                                         self_sector__val_rml_36;
                                                         Pervasives.print_int
                                                           x__val_rml_34;
                                                         Pervasives.print_int
                                                           y__val_rml_35
                                                   ))
                                               Lco_ctrl_tree_record.rml_pause)
                                             (Lco_ctrl_tree_record.rml_loop
                                               (Lco_ctrl_tree_record.rml_seq
                                                 Lco_ctrl_tree_record.rml_pause
                                                 (Lco_ctrl_tree_record.rml_compute
                                                   (function
                                                     | ()  ->
                                                         (let reports__val_rml_37
                                                                =
                                                                Lco_ctrl_tree_record.rml_pre_value
                                                                  sector_activation__sig_33
                                                            in ())
                                                     ))))
                                       ))
                             )
                     ):
                    (_) Lco_ctrl_tree_record.process)
              )
        ) 
;;
let get_von_neumann_neighbors =
      (function
        | cell__val_rml_39  ->
            (function
              | cell_array__val_rml_40  ->
                  (let x__val_rml_41 = (cell__val_rml_39).cell_x  in
                    let y__val_rml_42 = (cell__val_rml_39).cell_y  in
                      let neighbors__val_rml_43 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_41 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_43
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_40
                                  (Pervasives.(-) x__val_rml_41 1))
                                y__val_rml_42))
                              :: (Pervasives.(!) neighbors__val_rml_43))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_41 1)
                              (Pervasives.(!) maxx)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_43
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_40
                                    (Pervasives.(+) x__val_rml_41 1))
                                  y__val_rml_42))
                                :: (Pervasives.(!) neighbors__val_rml_43))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_42 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_43
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_40 x__val_rml_41)
                                  (Pervasives.(-) y__val_rml_42 1)))
                                :: (Pervasives.(!) neighbors__val_rml_43))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_42 1)
                              (Pervasives.(!) maxy)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_43
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_40 x__val_rml_41)
                                  (Pervasives.(+) y__val_rml_42 1)))
                                :: (Pervasives.(!) neighbors__val_rml_43))
                            else ();
                          Pervasives.(!) neighbors__val_rml_43)
              )
        ) 
;;
let rec activate_neighborhood =
          (function
            | self__val_rml_45  ->
                (function
                  | neighbors__val_rml_46  ->
                      (match neighbors__val_rml_46 with | ([])  -> ()
                       | ((dir__val_rml_47, cell__val_rml_48)) ::
                           (neighbors'__val_rml_49)  ->
                           (let info__val_rml_50 =
                                  make_info
                                    (opposite dir__val_rml_47)
                                    self__val_rml_45
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (cell__val_rml_48).cell_activation
                               info__val_rml_50;
                               activate_neighborhood
                                 self__val_rml_45 neighbors'__val_rml_49)
                       )
                  )
            ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_52  ->
                (function
                  | cell_array__val_rml_53  ->
                      (let maxx__val_rml_54 = Pervasives.(!) maxx  in
                        let maxy__val_rml_55 = Pervasives.(!) maxy  in
                          let x__val_rml_56 = (cell__val_rml_52).cell_x  in
                            let y__val_rml_57 = (cell__val_rml_52).cell_y  in
                              let rand_x__val_rml_58 =
                                    Random.int maxx__val_rml_54
                                 in
                                let rand_y__val_rml_59 =
                                      Random.int maxy__val_rml_55
                                   in
                                  if
                                    Pervasives.(&&)
                                      (Pervasives.(<>)
                                        x__val_rml_56 rand_x__val_rml_58)
                                      (Pervasives.(<>)
                                        y__val_rml_57 rand_y__val_rml_59)
                                    then
                                    (let other__val_rml_60 =
                                           Array.get
                                             (Array.get
                                               cell_array__val_rml_53
                                               rand_x__val_rml_58)
                                             rand_y__val_rml_59
                                       in
                                      let other_activation__val_rml_61 =
                                            (other__val_rml_60).cell_activation
                                         in
                                        Lco_ctrl_tree_record.rml_expr_emit_val
                                          (cell__val_rml_52).cell_activation
                                          (make_info
                                            Long_Lange other__val_rml_60);
                                          Lco_ctrl_tree_record.rml_expr_emit_val
                                            other_activation__val_rml_61
                                            (make_info
                                              Long_Lange cell__val_rml_52))
                                    else
                                    long_range_interaction
                                      cell__val_rml_52 cell_array__val_rml_53)
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_63  ->
            (function
              | get_neighbors__val_rml_64  ->
                  (function
                    | cell_behavior__val_rml_65  ->
                        (function
                          | x__val_rml_66  ->
                              (function
                                | y__val_rml_67  ->
                                    (function
                                      | status_init__val_rml_68  ->
                                          (function
                                            | cell_array__val_rml_69  ->
                                                (function
                                                  | sector_array__val_rml_70
                                                       ->
                                                      ((function
                                                         | ()  ->
                                                             Lco_ctrl_tree_record.rml_signal
                                                               (function
                                                                 | activation__sig_71
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    ((Pervasives.(/)
                                                                    x__val_rml_66
                                                                    (Pervasives.(!)
                                                                    sectormaxx)),
                                                                    (Pervasives.(/)
                                                                    y__val_rml_67
                                                                    (Pervasives.(!)
                                                                    sectormaxy)))
                                                                    )
                                                                    (function
                                                                    | sector_id__val_rml_72
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    new_cell
                                                                    x__val_rml_66
                                                                    y__val_rml_67
                                                                    activation__sig_71
                                                                    status_init__val_rml_68
                                                                    sector_id__val_rml_72
                                                                    )
                                                                    (function
                                                                    | self__val_rml_73
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_69
                                                                    x__val_rml_66)
                                                                    y__val_rml_67
                                                                    self__val_rml_73;
                                                                    draw_cell__val_rml_63
                                                                    self__val_rml_73
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_73.cell_neighborhood
                                                                    <-
                                                                    get_neighbors__val_rml_64
                                                                    self__val_rml_73
                                                                    cell_array__val_rml_69
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    long_range_interaction
                                                                    self__val_rml_73
                                                                    cell_array__val_rml_69;
                                                                    activate_neighborhood
                                                                    self__val_rml_73
                                                                    (self__val_rml_73).cell_neighborhood
                                                                    ))
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    Array.get
                                                                    (Array.get
                                                                    sector_array__val_rml_70
                                                                    (Pervasives.fst
                                                                    sector_id__val_rml_72))
                                                                    (Pervasives.snd
                                                                    sector_id__val_rml_72)
                                                                    )
                                                                    (function
                                                                    | sector__val_rml_74
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_emit_val
                                                                    (function
                                                                    | ()  ->
                                                                    (sector__val_rml_74).sector_activation
                                                                    )
                                                                    (function
                                                                    | ()  ->
                                                                    (self__val_rml_73).cell_status
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    (let 
                                                                    interactions__val_rml_75
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_71
                                                                     in
                                                                    cell_behavior__val_rml_65
                                                                    self__val_rml_73
                                                                    interactions__val_rml_75;
                                                                    draw_cell__val_rml_63
                                                                    self__val_rml_73;
                                                                    self__val_rml_73.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_73).time
                                                                    1) )) ))))
                                                                    ) )
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
        ) 
;;
let ebola =
      (function
        | cell__val_rml_77  ->
            (function
              | interactions__val_rml_78  ->
                  (let result__val_rml_79 = Pervasives.ref Susceptible  in
                    List.iter
                      (function
                        | info__val_rml_80  ->
                            (match info__val_rml_80 with
                             | {origin=Long_Lange;
                                status=Infectious; sector=_}  ->
                                 if
                                   Pervasives.(&&)
                                     (Pervasives.(=)
                                       (info__val_rml_80).sector
                                       (cell__val_rml_77).sector_id)
                                     (Pervasives.(<) (Random.float 1.) 0.04)
                                   then
                                   Pervasives.(:=) result__val_rml_79 Exposed
                                   else
                                   if Pervasives.(<) (Random.float 1.) 0.001
                                     then
                                     Pervasives.(:=)
                                       result__val_rml_79 Exposed
                                     else ()
                             | {origin=_; status=Infectious; sector=_}  ->
                                 if
                                   Pervasives.(&&)
                                     (Pervasives.(=)
                                       (info__val_rml_80).sector
                                       (cell__val_rml_77).sector_id)
                                     (Pervasives.(<) (Random.float 1.) 0.1)
                                   then
                                   Pervasives.(:=) result__val_rml_79 Exposed
                                   else
                                   if Pervasives.(<) (Random.float 1.) 0.001
                                     then
                                     Pervasives.(:=)
                                       result__val_rml_79 Exposed
                                     else ()
                             | {origin=_; status=_; sector=_}  -> () )
                        )
                      interactions__val_rml_78;
                      cell__val_rml_77.cell_status <-
                        (match (cell__val_rml_77).cell_status with
                         | Susceptible  ->
                             if
                               Pervasives.(=)
                                 (Pervasives.(!) result__val_rml_79) Exposed
                               then
                               (cell__val_rml_77.exposed_time <-
                                  (cell__val_rml_77).time;
                                 Exposed)
                               else Susceptible
                         | Exposed  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_77).time
                                   (cell__val_rml_77).exposed_time)
                                 delta
                               then Exposed else
                               (cell__val_rml_77.infectious_time <-
                                  (cell__val_rml_77).time;
                                 Infectious)
                         | Infectious  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_77).time
                                   (cell__val_rml_77).infectious_time)
                                 gamma
                               then Infectious else Removed
                         | Removed  -> Removed ))
              )
        ) 
;;
let cell_array_create =
      (function
        | tmp__val_rml_82  ->
            Array.make_matrix
              (Pervasives.(!) maxx) (Pervasives.(!) maxy) tmp__val_rml_82
        ) 
;;
let sector_array_create =
      (function
        | tmp__val_rml_84  ->
            Array.make_matrix
              (Pervasives.(!) sectorsize)
              (Pervasives.(!) sectorsize) tmp__val_rml_84
        ) 
;;
let get_status =
      (function
        | i__val_rml_86  ->
            (function
              | j__val_rml_87  ->
                  if Pervasives.(<) (Random.float 1.) 0.0005 then Infectious
                    else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_89  ->
            (function
              | get_neighbors__val_rml_90  ->
                  (function
                    | get_status__val_rml_91  ->
                        (function
                          | cell_behavior__val_rml_92  ->
                              (function
                                | cell_array__val_rml_93  ->
                                    (function
                                      | sector_array__val_rml_94  ->
                                          ((function
                                             | ()  ->
                                                 Lco_ctrl_tree_record.rml_fordopar
                                                   (function | ()  -> (0) )
                                                   (function
                                                     | ()  ->
                                                         Pervasives.(-)
                                                           (Pervasives.(!)
                                                             maxx)
                                                           1
                                                     )
                                                   true
                                                   (function
                                                     | i__val_rml_95  ->
                                                         Lco_ctrl_tree_record.rml_fordopar
                                                           (function
                                                             | ()  -> (0) )
                                                           (function
                                                             | ()  ->
                                                                 Pervasives.(-)
                                                                   (Pervasives.(!)
                                                                    maxy)
                                                                   1
                                                             )
                                                           true
                                                           (function
                                                             | j__val_rml_96
                                                                  ->
                                                                 Lco_ctrl_tree_record.rml_if
                                                                   (function
                                                                    | 
                                                                    ()  ->
                                                                    Pervasives.(&&)
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    j__val_rml_96
                                                                    (Pervasives.(!)
                                                                    sectormaxx))
                                                                    (0))
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    i__val_rml_95
                                                                    (Pervasives.(!)
                                                                    sectormaxy))
                                                                    (0)) )
                                                                   (Lco_ctrl_tree_record.rml_par
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_89
                                                                    get_neighbors__val_rml_90
                                                                    cell_behavior__val_rml_92
                                                                    i__val_rml_95
                                                                    j__val_rml_96
                                                                    (get_status__val_rml_91
                                                                    i__val_rml_95
                                                                    j__val_rml_96)
                                                                    cell_array__val_rml_93
                                                                    sector_array__val_rml_94
                                                                    ))
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    sector
                                                                    ((Pervasives.(/)
                                                                    i__val_rml_95
                                                                    (Pervasives.(!)
                                                                    sectormaxx)),
                                                                    (Pervasives.(/)
                                                                    j__val_rml_96
                                                                    (Pervasives.(!)
                                                                    sectormaxy)))
                                                                    sector_array__val_rml_94
                                                                    )))
                                                                   (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_89
                                                                    get_neighbors__val_rml_90
                                                                    cell_behavior__val_rml_92
                                                                    i__val_rml_95
                                                                    j__val_rml_96
                                                                    (get_status__val_rml_91
                                                                    i__val_rml_95
                                                                    j__val_rml_96)
                                                                    cell_array__val_rml_93
                                                                    sector_array__val_rml_94
                                                                    ))
                                                             )
                                                     )
                                             ):
                                            (_) Lco_ctrl_tree_record.process)
                                      )
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
                   | tmp_cell__sig_98  ->
                       Lco_ctrl_tree_record.rml_signal
                         (function
                           | tmp_sector__sig_99  ->
                               Lco_ctrl_tree_record.rml_def
                                 (function
                                   | ()  ->
                                       new_cell
                                         5
                                         5
                                         tmp_cell__sig_98
                                         Susceptible ((0), (0))
                                   )
                                 (function
                                   | dummy_cell__val_rml_100  ->
                                       Lco_ctrl_tree_record.rml_def
                                         (function
                                           | ()  ->
                                               new_sector
                                                 C
                                                 tmp_sector__sig_99
                                                 ((0), (0))
                                           )
                                         (function
                                           | dummy_sector__val_rml_101  ->
                                               Lco_ctrl_tree_record.rml_def
                                                 (function
                                                   | ()  ->
                                                       cell_array_create
                                                         dummy_cell__val_rml_100
                                                   )
                                                 (function
                                                   | cell_array__val_rml_102
                                                        ->
                                                       Lco_ctrl_tree_record.rml_def
                                                         (function
                                                           | ()  ->
                                                               sector_array_create
                                                                 dummy_sector__val_rml_101
                                                           )
                                                         (function
                                                           | sector_array__val_rml_103
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    draw_cell_gen
                                                                    color_of_status
                                                                   )
                                                                 (function
                                                                   | 
                                                                   draw__val_rml_104
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_par
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cellular_automaton_start
                                                                    draw__val_rml_104
                                                                    get_von_neumann_neighbors
                                                                    get_status
                                                                    ebola
                                                                    cell_array__val_rml_102
                                                                    sector_array__val_rml_103
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
                                                                    () ))
                                                                    Lco_ctrl_tree_record.rml_pause))
                                                                   )
                                                           )
                                                   )
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
