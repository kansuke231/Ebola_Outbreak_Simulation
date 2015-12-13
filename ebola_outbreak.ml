(* THIS FILE IS GENERATED. *)
(* rmlc -dtypes -n -1 -sampling -1.0 ebola_outbreak.rml  *)

open Implem_lco_ctrl_tree_record;;
open Printf
;;
type  status
= Susceptible |  Exposed |  Infectious |  Removed ;;
type  sector_status
= A |  B |  C ;;
type  dir
= Up |  Down |  Left |  Right |  Long_Range ;;
let opposite =
      (function
        | dir__val_rml_2  ->
            (match dir__val_rml_2 with | Up  -> Down | Down  -> Up
             | Left  -> Right | Right  -> Left | Long_Range  -> Long_Range )
        ) 
;;
type  info
= {  origin: dir ;   status: status ;   sector: (int * int)} ;;
type  neighborhood
= (info) list ;;
let maxx = 300 
;;
let maxy = 300 
;;
let sectormaxx = 10 
;;
let sectormaxy = 10 
;;
let sector_number = Pervasives.(/) maxx sectormaxx 
;;
let nox = false 
;;
let zoom = 4 
;;
let delta = 10 
;;
let gamma = 7 
;;
let tau = 0.18 
;;
let eta = 0.015 
;;
let t0 = 50 
;;
let compliance = 1. 
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
        | origin__val_rml_17  ->
            (function
              | cell__val_rml_18  ->
                  {origin=(origin__val_rml_17);
                   status=(cell__val_rml_18).cell_status;
                   sector=(cell__val_rml_18).sector_id}
              )
        ) 
;;
let new_cell =
      (function
        | x__val_rml_20  ->
            (function
              | y__val_rml_21  ->
                  (function
                    | activation__val_rml_22  ->
                        (function
                          | status__val_rml_23  ->
                              (function
                                | sector_id__val_rml_24  ->
                                    {cell_x=(x__val_rml_20);
                                     cell_y=(y__val_rml_21);
                                     cell_activation=(activation__val_rml_22);
                                     cell_status=(status__val_rml_23);
                                     cell_neighborhood=(([]));
                                     time=((0));
                                     exposed_time=((0));
                                     infectious_time=((0));
                                     compliant=(if
                                                 Pervasives.(<)
                                                   (Random.float 1.)
                                                   compliance
                                                 then true else false);
                                     sector_id=(sector_id__val_rml_24)}
                                )
                          )
                    )
              )
        ) 
;;
type  sector
= {
   sector_presence: (status, (status) list) Lco_ctrl_tree_record.event ; 
   sector_activation:
  (sector_status, (sector_status) list) Lco_ctrl_tree_record.event ; 
   coordinate: (int * int) ; 
  mutable sector_neighborhood: (sector) list ; 
  mutable sector_status: sector_status ; 
  mutable noninfected_time: int ;  mutable sector_time: int} ;;
let new_sector =
      (function
        | status__val_rml_26  ->
            (function
              | presence__val_rml_27  ->
                  (function
                    | activation__val_rml_28  ->
                        (function
                          | coordinate__val_rml_29  ->
                              {sector_status=(status__val_rml_26);
                               sector_presence=(presence__val_rml_27);
                               sector_activation=(activation__val_rml_28);
                               coordinate=(coordinate__val_rml_29);
                               sector_neighborhood=(([]));
                               noninfected_time=((0)); sector_time=((0))}
                          )
                    )
              )
        ) 
;;
let line_color =
      (function
        | sector_status__val_rml_31  ->
            (match sector_status__val_rml_31 with | A  -> Graphics.red
             | B  -> Graphics.yellow | C  -> Graphics.blue )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_33  ->
            (function
              | c__val_rml_34  ->
                  (function
                    | sector_array__val_rml_35  ->
                        Graphics.set_color
                          (color_of_cell__val_rml_33 c__val_rml_34);
                          Graphics.fill_rect
                            (Pervasives.( * ) (c__val_rml_34).cell_x zoom)
                            (Pervasives.( * ) (c__val_rml_34).cell_y zoom)
                            zoom zoom;
                          (let (x__val_rml_36, y__val_rml_37) =
                                 (c__val_rml_34).sector_id
                             in
                            let sector__val_rml_38 =
                                  Array.get
                                    (Array.get
                                      sector_array__val_rml_35 x__val_rml_36)
                                    y__val_rml_37
                               in
                              let color__val_rml_39 =
                                    if
                                      Pervasives.(<)
                                        (c__val_rml_34).time
                                        (Pervasives.(+) t0 gamma)
                                      then Graphics.black else
                                      line_color
                                        (sector__val_rml_38).sector_status
                                 in
                                Graphics.set_color color__val_rml_39;
                                  Graphics.moveto
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_x zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_y zoom);
                                  Graphics.lineto
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_x zoom)
                                    (Pervasives.( * )
                                      (Pervasives.(+)
                                        (c__val_rml_34).cell_y 1)
                                      zoom);
                                  Graphics.moveto
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_x zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_y zoom);
                                  Graphics.lineto
                                    (Pervasives.( * )
                                      (Pervasives.(+)
                                        (c__val_rml_34).cell_x 1)
                                      zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_34).cell_y zoom);
                                  if
                                    Pervasives.(=)
                                      (Pervasives.(mod)
                                        (c__val_rml_34).cell_x sectormaxx)
                                      (0)
                                    then
                                    (Graphics.set_color Graphics.black;
                                       Graphics.moveto
                                         (Pervasives.( * )
                                           (c__val_rml_34).cell_x zoom)
                                         (Pervasives.( * )
                                           (c__val_rml_34).cell_y zoom);
                                      Graphics.lineto
                                        (Pervasives.( * )
                                          (c__val_rml_34).cell_x zoom)
                                        (Pervasives.( * )
                                          (Pervasives.(+)
                                            (c__val_rml_34).cell_y 1)
                                          zoom))
                                    else
                                    if
                                      Pervasives.(=)
                                        (Pervasives.(mod)
                                          (c__val_rml_34).cell_y sectormaxy)
                                        (0)
                                      then
                                      (Graphics.set_color Graphics.black;
                                         Graphics.moveto
                                           (Pervasives.( * )
                                             (c__val_rml_34).cell_x zoom)
                                           (Pervasives.( * )
                                             (c__val_rml_34).cell_y zoom);
                                        Graphics.lineto
                                          (Pervasives.( * )
                                            (Pervasives.(+)
                                              (c__val_rml_34).cell_x 1)
                                            zoom)
                                          (Pervasives.( * )
                                            (c__val_rml_34).cell_y zoom))
                                      else ())
                    )
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_41  ->
            (match (s__val_rml_41).cell_status with
             | Susceptible  -> Graphics.rgb 102 102 102
             | Exposed  -> Graphics.yellow | Infectious  -> Graphics.red
             | Removed  -> Graphics.black )
        ) 
;;
let get_cell_neighbors =
      (function
        | cell__val_rml_43  ->
            (function
              | cell_array__val_rml_44  ->
                  (let x__val_rml_45 = (cell__val_rml_43).cell_x  in
                    let y__val_rml_46 = (cell__val_rml_43).cell_y  in
                      let neighbors__val_rml_47 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_45 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_47
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_44
                                  (Pervasives.(-) x__val_rml_45 1))
                                y__val_rml_46))
                              :: (Pervasives.(!) neighbors__val_rml_47))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_45 1) maxx
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_47
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_44
                                    (Pervasives.(+) x__val_rml_45 1))
                                  y__val_rml_46))
                                :: (Pervasives.(!) neighbors__val_rml_47))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_46 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_47
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_44 x__val_rml_45)
                                  (Pervasives.(-) y__val_rml_46 1)))
                                :: (Pervasives.(!) neighbors__val_rml_47))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_46 1) maxy
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_47
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_44 x__val_rml_45)
                                  (Pervasives.(+) y__val_rml_46 1)))
                                :: (Pervasives.(!) neighbors__val_rml_47))
                            else ();
                          Pervasives.(!) neighbors__val_rml_47)
              )
        ) 
;;
let get_sector_neighbors =
      (function
        | sector__val_rml_49  ->
            (function
              | sector_array__val_rml_50  ->
                  (let (x__val_rml_51, y__val_rml_52) =
                         (sector__val_rml_49).coordinate
                     in
                    let neighbors__val_rml_53 = Pervasives.ref ([])  in
                      if Pervasives.(<=) (0) (Pervasives.(-) x__val_rml_51 1)
                        then
                        Pervasives.(:=)
                          neighbors__val_rml_53
                          ((Array.get
                             (Array.get
                               sector_array__val_rml_50
                               (Pervasives.(-) x__val_rml_51 1))
                             y__val_rml_52)
                            :: (Pervasives.(!) neighbors__val_rml_53))
                        else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) x__val_rml_51 1) sector_number
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_53
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_50
                                 (Pervasives.(+) x__val_rml_51 1))
                               y__val_rml_52)
                              :: (Pervasives.(!) neighbors__val_rml_53))
                          else ();
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) y__val_rml_52 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_53
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_50 x__val_rml_51)
                               (Pervasives.(-) y__val_rml_52 1))
                              :: (Pervasives.(!) neighbors__val_rml_53))
                          else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) y__val_rml_52 1) sector_number
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_53
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_50 x__val_rml_51)
                               (Pervasives.(+) y__val_rml_52 1))
                              :: (Pervasives.(!) neighbors__val_rml_53))
                          else ();
                        Pervasives.(!) neighbors__val_rml_53)
              )
        ) 
;;
let ebola =
      (function
        | cell__val_rml_55  ->
            (function
              | interactions__val_rml_56  ->
                  (function
                    | sector_array__val_rml_57  ->
                        (let result__val_rml_58 = Pervasives.ref Susceptible 
                          in
                          List.iter
                            (function
                              | info__val_rml_59  ->
                                  (let (x__val_rml_60, y__val_rml_61) =
                                         (info__val_rml_59).sector
                                     in
                                    let sector__val_rml_62 =
                                          Array.get
                                            (Array.get
                                              sector_array__val_rml_57
                                              x__val_rml_60)
                                            y__val_rml_61
                                       in
                                      match (sector__val_rml_62).sector_status with
                                      | C  -> ()
                                      | _  ->
                                          (match info__val_rml_59 with
                                           | {origin=Long_Range;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(<)
                                                   (Random.float 1.) eta
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_58 Exposed
                                                 else ()
                                           | {origin=_;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(<)
                                                   (Random.float 1.) tau
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_58 Exposed
                                                 else ()
                                           | {origin=_; status=_; sector=_}
                                                -> ()
                                           )
                                      )
                              )
                            interactions__val_rml_56;
                            cell__val_rml_55.cell_status <-
                              (match (cell__val_rml_55).cell_status with
                               | Susceptible  ->
                                   if
                                     Pervasives.(=)
                                       (Pervasives.(!) result__val_rml_58)
                                       Exposed
                                     then
                                     (cell__val_rml_55.exposed_time <-
                                        (cell__val_rml_55).time;
                                       Exposed)
                                     else Susceptible
                               | Exposed  ->
                                   if
                                     Pervasives.(<)
                                       (Pervasives.(-)
                                         (cell__val_rml_55).time
                                         (cell__val_rml_55).exposed_time)
                                       delta
                                     then Exposed else
                                     (cell__val_rml_55.infectious_time <-
                                        (cell__val_rml_55).time;
                                       Infectious)
                               | Infectious  ->
                                   if
                                     Pervasives.(<)
                                       (Pervasives.(-)
                                         (cell__val_rml_55).time
                                         (cell__val_rml_55).infectious_time)
                                       gamma
                                     then Infectious else Removed
                               | Removed  -> Removed ))
                    )
              )
        ) 
;;
let isolated =
      (function
        | cell__val_rml_64  ->
            cell__val_rml_64.cell_status <-
              (match (cell__val_rml_64).cell_status with
               | Susceptible  -> Susceptible
               | Exposed  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_64).time
                         (cell__val_rml_64).exposed_time)
                       delta
                     then Exposed else
                     (cell__val_rml_64.infectious_time <-
                        (cell__val_rml_64).time;
                       Infectious)
               | Infectious  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_64).time
                         (cell__val_rml_64).infectious_time)
                       gamma
                     then Infectious else Removed
               | Removed  -> Removed )
        ) 
;;
let observer =
      (function
        | cell_array__val_rml_66  ->
            (function
              | sector_array__val_rml_67  ->
                  (function
                    | seir_signals__val_rml_68  ->
                        ((function
                           | ()  ->
                               (let (s__val_rml_69,
                                     e__val_rml_70,
                                     i__val_rml_71, r__val_rml_72) =
                                      seir_signals__val_rml_68
                                  in
                                 Lco_ctrl_tree_record.rml_def
                                   (function | ()  -> Pervasives.ref (0) )
                                   (function
                                     | current_time__val_rml_73  ->
                                         Lco_ctrl_tree_record.rml_def
                                           (function
                                             | ()  -> Pervasives.ref (0) )
                                           (function
                                             | no_infected__val_rml_74  ->
                                                 Lco_ctrl_tree_record.rml_seq
                                                   Lco_ctrl_tree_record.rml_pause
                                                   (Lco_ctrl_tree_record.rml_loop
                                                     (Lco_ctrl_tree_record.rml_seq
                                                       Lco_ctrl_tree_record.rml_pause
                                                       (Lco_ctrl_tree_record.rml_def
                                                         (function
                                                           | ()  ->
                                                               (Pervasives.(!)
                                                                 current_time__val_rml_73)
                                                                 ::
                                                                 ((Lco_ctrl_tree_record.rml_pre_value
                                                                    s__val_rml_69)
                                                                   ::
                                                                   ((Lco_ctrl_tree_record.rml_pre_value
                                                                    e__val_rml_70)
                                                                    ::
                                                                    ((Lco_ctrl_tree_record.rml_pre_value
                                                                    i__val_rml_71)
                                                                    ::
                                                                    ((Lco_ctrl_tree_record.rml_pre_value
                                                                    r__val_rml_72)
                                                                    :: 
                                                                    ([])))))
                                                           )
                                                         (function
                                                           | stats__val_rml_75
                                                                ->
                                                               Lco_ctrl_tree_record.rml_seq
                                                                 (Lco_ctrl_tree_record.rml_compute
                                                                   (function
                                                                    | 
                                                                    ()  ->
                                                                    List.iter
                                                                    (function
                                                                    | num__val_rml_76
                                                                     ->
                                                                    Pervasives.print_int
                                                                    num__val_rml_76;
                                                                    Pervasives.print_string
                                                                    " " )
                                                                    stats__val_rml_75;
                                                                    Pervasives.print_endline
                                                                    "";
                                                                    Pervasives.(:=)
                                                                    current_time__val_rml_73
                                                                    (Pervasives.(+)
                                                                    (Pervasives.(!)
                                                                    current_time__val_rml_73)
                                                                    1) ))
                                                                 (Lco_ctrl_tree_record.rml_if
                                                                   (function
                                                                    | 
                                                                    ()  ->
                                                                    Pervasives.(=)
                                                                    (Lco_ctrl_tree_record.rml_pre_value
                                                                    i__val_rml_71)
                                                                    (0) )
                                                                   (Lco_ctrl_tree_record.rml_if
                                                                    (function
                                                                    | ()  ->
                                                                    Pervasives.(>)
                                                                    (Pervasives.(!)
                                                                    no_infected__val_rml_74)
                                                                    (Pervasives.(+)
                                                                    delta 1)
                                                                    )
                                                                    Lco_ctrl_tree_record.rml_halt
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Pervasives.(:=)
                                                                    no_infected__val_rml_74
                                                                    (Pervasives.(+)
                                                                    (Pervasives.(!)
                                                                    no_infected__val_rml_74)
                                                                    1) )))
                                                                   (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Pervasives.(:=)
                                                                    no_infected__val_rml_74
                                                                    (0) )))
                                                           ))))
                                             )
                                     ))
                           ):
                          (_) Lco_ctrl_tree_record.process)
                    )
              )
        ) 
;;
let rec activate_sector_neighborhood =
          (function
            | self__val_rml_78  ->
                (function
                  | neighbors__val_rml_79  ->
                      (match neighbors__val_rml_79 with | ([])  -> ()
                       | (sector__val_rml_80) :: (neighbors'__val_rml_81)  ->
                           (let info__val_rml_82 =
                                  (self__val_rml_78).sector_status
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (sector__val_rml_80).sector_activation
                               info__val_rml_82;
                               activate_sector_neighborhood
                                 self__val_rml_78 neighbors'__val_rml_81)
                       )
                  )
            ) 
;;
let sector =
      (function
        | coordinate__val_rml_84  ->
            (function
              | sector_array__val_rml_85  ->
                  ((function
                     | ()  ->
                         Lco_ctrl_tree_record.rml_signal
                           (function
                             | sector_presence__sig_86  ->
                                 Lco_ctrl_tree_record.rml_signal
                                   (function
                                     | sector_activation__sig_87  ->
                                         (let (x__val_rml_88, y__val_rml_89)
                                                = coordinate__val_rml_84
                                            in
                                           Lco_ctrl_tree_record.rml_def
                                             (function
                                               | ()  ->
                                                   new_sector
                                                     A
                                                     sector_presence__sig_86
                                                     sector_activation__sig_87
                                                     coordinate__val_rml_84
                                               )
                                             (function
                                               | self_sector__val_rml_90  ->
                                                   Lco_ctrl_tree_record.rml_seq
                                                     (Lco_ctrl_tree_record.rml_seq
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 Array.set
                                                                   (Array.get
                                                                    sector_array__val_rml_85
                                                                    x__val_rml_88)
                                                                   y__val_rml_89
                                                                   self_sector__val_rml_90
                                                             ))
                                                         Lco_ctrl_tree_record.rml_pause)
                                                       (Lco_ctrl_tree_record.rml_compute
                                                         (function
                                                           | ()  ->
                                                               self_sector__val_rml_90.sector_neighborhood
                                                                 <-
                                                                 get_sector_neighbors
                                                                   self_sector__val_rml_90
                                                                   sector_array__val_rml_85
                                                           )))
                                                     (Lco_ctrl_tree_record.rml_loop
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_seq
                                                           (Lco_ctrl_tree_record.rml_compute
                                                             (function
                                                               | ()  ->
                                                                   activate_sector_neighborhood
                                                                    self_sector__val_rml_90
                                                                    (self_sector__val_rml_90).sector_neighborhood
                                                               ))
                                                           Lco_ctrl_tree_record.rml_pause)
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 (let 
                                                                   sector_reports__val_rml_91
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_activation__sig_87
                                                                    in
                                                                   if
                                                                    Pervasives.(>)
                                                                    (self_sector__val_rml_90).sector_time
                                                                    (Pervasives.(+)
                                                                    t0 gamma)
                                                                    then
                                                                    if
                                                                    Pervasives.(!=)
                                                                    (self_sector__val_rml_90).sector_status
                                                                    C then
                                                                    (let 
                                                                    cell_reports__val_rml_92
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_presence__sig_86
                                                                     in
                                                                    match 
                                                                    cell_reports__val_rml_92 with
                                                                    | 
                                                                    ([])  ->
                                                                    if
                                                                    Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (self_sector__val_rml_90).noninfected_time
                                                                    (Pervasives.(+)
                                                                    gamma 1))
                                                                    (Pervasives.not
                                                                    (List.mem
                                                                    A
                                                                    sector_reports__val_rml_91))
                                                                    then
                                                                    self_sector__val_rml_90.sector_status
                                                                    <- 
                                                                    C else
                                                                    self_sector__val_rml_90.sector_status
                                                                    <- 
                                                                    B;
                                                                    self_sector__val_rml_90.noninfected_time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self_sector__val_rml_90).noninfected_time
                                                                    1
                                                                    | 
                                                                    _  ->
                                                                    self_sector__val_rml_90.sector_status
                                                                    <- 
                                                                    A;
                                                                    self_sector__val_rml_90.noninfected_time
                                                                    <- 
                                                                    (0) )
                                                                    else 
                                                                    () else
                                                                    ();
                                                                    self_sector__val_rml_90.sector_time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self_sector__val_rml_90).sector_time
                                                                    1)
                                                             ))))
                                               ))
                                     )
                             )
                     ):
                    (_) Lco_ctrl_tree_record.process)
              )
        ) 
;;
let rec activate_neighborhood =
          (function
            | self__val_rml_94  ->
                (function
                  | neighbors__val_rml_95  ->
                      (match neighbors__val_rml_95 with | ([])  -> ()
                       | ((dir__val_rml_96, cell__val_rml_97)) ::
                           (neighbors'__val_rml_98)  ->
                           (let info__val_rml_99 =
                                  make_info
                                    (opposite dir__val_rml_96)
                                    self__val_rml_94
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (cell__val_rml_97).cell_activation
                               info__val_rml_99;
                               activate_neighborhood
                                 self__val_rml_94 neighbors'__val_rml_98)
                       )
                  )
            ) 
;;
let get_sector_status =
      (function
        | cell__val_rml_101  ->
            (function
              | sector_array__val_rml_102  ->
                  (let (x__val_rml_103, y__val_rml_104) =
                         (cell__val_rml_101).sector_id
                     in
                    let own_sector__val_rml_105 =
                          (Array.get
                            (Array.get
                              sector_array__val_rml_102 x__val_rml_103)
                            y__val_rml_104).sector_status
                       in own_sector__val_rml_105)
              )
        ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_107  ->
                (function
                  | cell_array__val_rml_108  ->
                      (function
                        | sector_array__val_rml_109  ->
                            (let x__val_rml_112 = (cell__val_rml_107).cell_x 
                              in
                              let y__val_rml_113 = (cell__val_rml_107).cell_y
                                 in
                                let rand_x__val_rml_114 = Random.int maxx  in
                                  let rand_y__val_rml_115 = Random.int maxy 
                                    in
                                    if
                                      Pervasives.(&&)
                                        (Pervasives.(<>)
                                          x__val_rml_112 rand_x__val_rml_114)
                                        (Pervasives.(<>)
                                          y__val_rml_113 rand_y__val_rml_115)
                                      then
                                      (let other__val_rml_116 =
                                             Array.get
                                               (Array.get
                                                 cell_array__val_rml_108
                                                 rand_x__val_rml_114)
                                               rand_y__val_rml_115
                                         in
                                        if
                                          Pervasives.(=)
                                            (get_sector_status
                                              other__val_rml_116
                                              sector_array__val_rml_109)
                                            C
                                          then () else
                                          (let other_activation__val_rml_117
                                                 =
                                                 (other__val_rml_116).cell_activation
                                             in
                                            Lco_ctrl_tree_record.rml_expr_emit_val
                                              (cell__val_rml_107).cell_activation
                                              (make_info
                                                Long_Range other__val_rml_116);
                                              Lco_ctrl_tree_record.rml_expr_emit_val
                                                other_activation__val_rml_117
                                                (make_info
                                                  Long_Range
                                                  cell__val_rml_107)))
                                      else
                                      long_range_interaction
                                        cell__val_rml_107
                                        cell_array__val_rml_108
                                        sector_array__val_rml_109)
                        )
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_119  ->
            (function
              | x__val_rml_120  ->
                  (function
                    | y__val_rml_121  ->
                        (function
                          | status_init__val_rml_122  ->
                              (function
                                | cell_array__val_rml_123  ->
                                    (function
                                      | sector_array__val_rml_124  ->
                                          (function
                                            | seir_signals__val_rml_125  ->
                                                ((function
                                                   | ()  ->
                                                       Lco_ctrl_tree_record.rml_signal
                                                         (function
                                                           | activation__sig_126
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    ((Pervasives.(/)
                                                                    x__val_rml_120
                                                                    sectormaxx),
                                                                    (Pervasives.(/)
                                                                    y__val_rml_121
                                                                    sectormaxy))
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_id__val_rml_127
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    new_cell
                                                                    x__val_rml_120
                                                                    y__val_rml_121
                                                                    activation__sig_126
                                                                    status_init__val_rml_122
                                                                    sector_id__val_rml_127
                                                                    )
                                                                    (function
                                                                    | self__val_rml_128
                                                                     ->
                                                                    (let 
                                                                    (s__val_rml_129,
                                                                    e__val_rml_130,
                                                                    i__val_rml_131,
                                                                    r__val_rml_132)
                                                                    =
                                                                    seir_signals__val_rml_125
                                                                     in
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_123
                                                                    x__val_rml_120)
                                                                    y__val_rml_121
                                                                    self__val_rml_128;
                                                                    draw_cell__val_rml_119
                                                                    self__val_rml_128
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_128.cell_neighborhood
                                                                    <-
                                                                    get_cell_neighbors
                                                                    self__val_rml_128
                                                                    cell_array__val_rml_123
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    get_sector_status
                                                                    self__val_rml_128
                                                                    sector_array__val_rml_124
                                                                    )
                                                                    (function
                                                                    | own_sector__val_rml_133
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    if
                                                                    Pervasives.(||)
                                                                    (Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (Pervasives.(-)
                                                                    (self__val_rml_128).time
                                                                    (self__val_rml_128).infectious_time)
                                                                    1)
                                                                    (Pervasives.(&&)
                                                                    (self__val_rml_128).compliant
                                                                    (Pervasives.(>)
                                                                    (self__val_rml_128).time
                                                                    t0)))
                                                                    (Pervasives.(=)
                                                                    own_sector__val_rml_133
                                                                    C) then
                                                                    () else
                                                                    (long_range_interaction
                                                                    self__val_rml_128
                                                                    cell_array__val_rml_123
                                                                    sector_array__val_rml_124;
                                                                    activate_neighborhood
                                                                    self__val_rml_128
                                                                    (self__val_rml_128).cell_neighborhood)
                                                                    ))
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    Array.get
                                                                    (Array.get
                                                                    sector_array__val_rml_124
                                                                    (Pervasives.fst
                                                                    sector_id__val_rml_127))
                                                                    (Pervasives.snd
                                                                    sector_id__val_rml_127)
                                                                    )
                                                                    (function
                                                                    | sector__val_rml_134
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    (match 
                                                                    (self__val_rml_128).cell_status with
                                                                    | 
                                                                    Susceptible
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    s__val_rml_129
                                                                    1
                                                                    | 
                                                                    Exposed
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    e__val_rml_130
                                                                    1
                                                                    | 
                                                                    Infectious
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    i__val_rml_131
                                                                    1;
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    (sector__val_rml_134).sector_presence
                                                                    (self__val_rml_128).cell_status
                                                                    | 
                                                                    Removed
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    r__val_rml_132
                                                                    1 ) ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    draw_cell__val_rml_119
                                                                    self__val_rml_128
                                                                    sector_array__val_rml_124;
                                                                    (let 
                                                                    own_sector__val_rml_135
                                                                    =
                                                                    get_sector_status
                                                                    self__val_rml_128
                                                                    sector_array__val_rml_124
                                                                     in
                                                                    let 
                                                                    interactions__val_rml_136
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_126
                                                                     in
                                                                    if
                                                                    Pervasives.(<)
                                                                    (self__val_rml_128).time
                                                                    t0 then
                                                                    ebola
                                                                    self__val_rml_128
                                                                    interactions__val_rml_136
                                                                    sector_array__val_rml_124
                                                                    else
                                                                    if
                                                                    Pervasives.(||)
                                                                    (Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (Pervasives.(-)
                                                                    (self__val_rml_128).time
                                                                    (self__val_rml_128).infectious_time)
                                                                    1)
                                                                    (self__val_rml_128).compliant)
                                                                    (Pervasives.(=)
                                                                    own_sector__val_rml_135
                                                                    C) then
                                                                    isolated
                                                                    self__val_rml_128
                                                                    else
                                                                    ebola
                                                                    self__val_rml_128
                                                                    interactions__val_rml_136
                                                                    sector_array__val_rml_124;
                                                                    self__val_rml_128.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_128).time
                                                                    1) )) ))
                                                                    )))) )
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
let cell_array_create =
      (function
        | tmp__val_rml_138  -> Array.make_matrix maxx maxy tmp__val_rml_138 )

;;
let sector_array_create =
      (function
        | tmp__val_rml_140  ->
            Array.make_matrix sector_number sector_number tmp__val_rml_140
        ) 
;;
let get_status =
      (function
        | i__val_rml_142  ->
            (function
              | j__val_rml_143  ->
                  if Pervasives.(<) (Random.float 1.) 0.0002 then Infectious
                    else
                    if Pervasives.(<) (Random.float 1.) 0.0002 then Exposed
                      else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_145  ->
            (function
              | cell_array__val_rml_146  ->
                  (function
                    | sector_array__val_rml_147  ->
                        (function
                          | seir_signals__val_rml_148  ->
                              ((function
                                 | ()  ->
                                     Lco_ctrl_tree_record.rml_fordopar
                                       (function | ()  -> (0) )
                                       (function
                                         | ()  -> Pervasives.(-) maxx 1 )
                                       true
                                       (function
                                         | i__val_rml_149  ->
                                             Lco_ctrl_tree_record.rml_fordopar
                                               (function | ()  -> (0) )
                                               (function
                                                 | ()  ->
                                                     Pervasives.(-) maxy 1
                                                 )
                                               true
                                               (function
                                                 | j__val_rml_150  ->
                                                     Lco_ctrl_tree_record.rml_if
                                                       (function
                                                         | ()  ->
                                                             Pervasives.(&&)
                                                               (Pervasives.(=)
                                                                 (Pervasives.(mod)
                                                                   j__val_rml_150
                                                                   sectormaxx)
                                                                 (0))
                                                               (Pervasives.(=)
                                                                 (Pervasives.(mod)
                                                                   i__val_rml_149
                                                                   sectormaxy)
                                                                 (0))
                                                         )
                                                       (Lco_ctrl_tree_record.rml_par
                                                         (Lco_ctrl_tree_record.rml_run
                                                           (function
                                                             | ()  ->
                                                                 cell
                                                                   draw_cell__val_rml_145
                                                                   i__val_rml_149
                                                                   j__val_rml_150
                                                                   (get_status
                                                                    i__val_rml_149
                                                                    j__val_rml_150)
                                                                   cell_array__val_rml_146
                                                                   sector_array__val_rml_147
                                                                   seir_signals__val_rml_148
                                                             ))
                                                         (Lco_ctrl_tree_record.rml_run
                                                           (function
                                                             | ()  ->
                                                                 sector
                                                                   ((Pervasives.(/)
                                                                    i__val_rml_149
                                                                    sectormaxx),
                                                                    (Pervasives.(/)
                                                                    j__val_rml_150
                                                                    sectormaxy))
                                                                   sector_array__val_rml_147
                                                             )))
                                                       (Lco_ctrl_tree_record.rml_run
                                                         (function
                                                           | ()  ->
                                                               cell
                                                                 draw_cell__val_rml_145
                                                                 i__val_rml_149
                                                                 j__val_rml_150
                                                                 (get_status
                                                                   i__val_rml_149
                                                                   j__val_rml_150)
                                                                 cell_array__val_rml_146
                                                                 sector_array__val_rml_147
                                                                 seir_signals__val_rml_148
                                                           ))
                                                 )
                                         )
                                 ):
                                (_) Lco_ctrl_tree_record.process)
                          )
                    )
              )
        ) 
;;
let build_seir =
      (let s__sig_152 =
             Lco_ctrl_tree_record.rml_global_signal_combine
               (0) Pervasives.(+)
         in
        let e__sig_153 =
              Lco_ctrl_tree_record.rml_global_signal_combine
                (0) Pervasives.(+)
           in
          let i__sig_154 =
                Lco_ctrl_tree_record.rml_global_signal_combine
                  (0) Pervasives.(+)
             in
            let r__sig_155 =
                  Lco_ctrl_tree_record.rml_global_signal_combine
                    (0) Pervasives.(+)
               in (s__sig_152, e__sig_153, i__sig_154, r__sig_155)) 
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
                                 (Pervasives.( * ) maxx zoom))
                               (Pervasives.(^)
                                 "x"
                                 (Pervasives.string_of_int
                                   (Pervasives.( * ) maxy zoom)))));
                         Graphics.auto_synchronize false
                   ))
               (Lco_ctrl_tree_record.rml_signal
                 (function
                   | tmp_cell__sig_158  ->
                       Lco_ctrl_tree_record.rml_signal
                         (function
                           | tmp_sector_p__sig_159  ->
                               Lco_ctrl_tree_record.rml_signal
                                 (function
                                   | tmp_sector_a__sig_160  ->
                                       Lco_ctrl_tree_record.rml_def
                                         (function
                                           | ()  ->
                                               new_cell
                                                 5
                                                 5
                                                 tmp_cell__sig_158
                                                 Susceptible ((0), (0))
                                           )
                                         (function
                                           | dummy_cell__val_rml_162  ->
                                               Lco_ctrl_tree_record.rml_def
                                                 (function
                                                   | ()  ->
                                                       new_sector
                                                         C
                                                         tmp_sector_p__sig_159
                                                         tmp_sector_a__sig_160
                                                         ((0), (0))
                                                   )
                                                 (function
                                                   | dummy_sector__val_rml_163
                                                        ->
                                                       Lco_ctrl_tree_record.rml_def
                                                         (function
                                                           | ()  ->
                                                               cell_array_create
                                                                 dummy_cell__val_rml_162
                                                           )
                                                         (function
                                                           | cell_array__val_rml_164
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    sector_array_create
                                                                    dummy_sector__val_rml_163
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_array__val_rml_165
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    draw_cell_gen
                                                                    color_of_status
                                                                    )
                                                                    (function
                                                                    | draw__val_rml_166
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_par_n
                                                                    ((Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cellular_automaton_start
                                                                    draw__val_rml_166
                                                                    cell_array__val_rml_164
                                                                    sector_array__val_rml_165
                                                                    build_seir
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_nothing)
                                                                    ::
                                                                    ((Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    observer
                                                                    cell_array__val_rml_164
                                                                    sector_array__val_rml_165
                                                                    build_seir
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_nothing)
                                                                    ::
                                                                    ((Lco_ctrl_tree_record.rml_loop
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
                                                                    :: 
                                                                    ([])))) )
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
