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
let sectornumber =
      Pervasives.ref
        (Pervasives.(/) (Pervasives.(!) maxx) (Pervasives.(!) sectormaxx)) 
;;
let nox = Pervasives.ref false 
;;
let zoom = Pervasives.ref 3 
;;
let delta = 5 
;;
let gamma = 6 
;;
let tzero = Pervasives.ref 15 
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
        | origin__val_rml_14  ->
            (function
              | cell__val_rml_15  ->
                  {origin=(origin__val_rml_14);
                   status=(cell__val_rml_15).cell_status;
                   sector=(cell__val_rml_15).sector_id}
              )
        ) 
;;
let new_cell =
      (function
        | x__val_rml_17  ->
            (function
              | y__val_rml_18  ->
                  (function
                    | activation__val_rml_19  ->
                        (function
                          | status__val_rml_20  ->
                              (function
                                | sector_id__val_rml_21  ->
                                    {cell_x=(x__val_rml_17);
                                     cell_y=(y__val_rml_18);
                                     cell_activation=(activation__val_rml_19);
                                     cell_status=(status__val_rml_20);
                                     cell_neighborhood=(([]));
                                     time=((0));
                                     exposed_time=((0));
                                     infectious_time=((0));
                                     compliant=(if
                                                 Pervasives.(<)
                                                   (Random.float 1.) 0.4
                                                 then true else false);
                                     sector_id=(sector_id__val_rml_21)}
                                )
                          )
                    )
              )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_23  ->
            (function
              | c__val_rml_24  ->
                  Graphics.set_color
                    (color_of_cell__val_rml_23 c__val_rml_24);
                    Graphics.fill_rect
                      (Pervasives.( * )
                        (c__val_rml_24).cell_x (Pervasives.(!) zoom))
                      (Pervasives.( * )
                        (c__val_rml_24).cell_y (Pervasives.(!) zoom))
                      (Pervasives.(!) zoom) (Pervasives.(!) zoom);
                    if
                      Pervasives.(=)
                        (Pervasives.(mod)
                          (c__val_rml_24).cell_x (Pervasives.(!) sectormaxx))
                        (0)
                      then
                      (Graphics.set_color Graphics.black;
                         Graphics.moveto
                           (Pervasives.( * )
                             (c__val_rml_24).cell_x (Pervasives.(!) zoom))
                           (Pervasives.( * )
                             (c__val_rml_24).cell_y (Pervasives.(!) zoom));
                        Graphics.lineto
                          (Pervasives.( * )
                            (c__val_rml_24).cell_x (Pervasives.(!) zoom))
                          (Pervasives.( * )
                            (Pervasives.(+) (c__val_rml_24).cell_y 1)
                            (Pervasives.(!) zoom)))
                      else
                      if
                        Pervasives.(=)
                          (Pervasives.(mod)
                            (c__val_rml_24).cell_y
                            (Pervasives.(!) sectormaxy))
                          (0)
                        then
                        (Graphics.set_color Graphics.black;
                           Graphics.moveto
                             (Pervasives.( * )
                               (c__val_rml_24).cell_x (Pervasives.(!) zoom))
                             (Pervasives.( * )
                               (c__val_rml_24).cell_y (Pervasives.(!) zoom));
                          Graphics.lineto
                            (Pervasives.( * )
                              (Pervasives.(+) (c__val_rml_24).cell_x 1)
                              (Pervasives.(!) zoom))
                            (Pervasives.( * )
                              (c__val_rml_24).cell_y (Pervasives.(!) zoom)))
                        else ()
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_26  ->
            (match (s__val_rml_26).cell_status with
             | Susceptible  -> Graphics.blue | Exposed  -> Graphics.green
             | Infectious  -> Graphics.red | Removed  -> Graphics.white )
        ) 
;;
type  sector
= {
   sector_presence: (status, (status) list) Lco_ctrl_tree_record.event ; 
   sector_activation:
  (sector_status, (sector_status) list) Lco_ctrl_tree_record.event ; 
   coordinate: (int * int) ; 
  mutable sector_neighborhood: (sector) list ; 
  mutable sector_status: sector_status ;  mutable noninfected_time: int} ;;
let new_sector =
      (function
        | status__val_rml_28  ->
            (function
              | presence__val_rml_29  ->
                  (function
                    | activation__val_rml_30  ->
                        (function
                          | coordinate__val_rml_31  ->
                              {sector_status=(status__val_rml_28);
                               sector_presence=(presence__val_rml_29);
                               sector_activation=(activation__val_rml_30);
                               coordinate=(coordinate__val_rml_31);
                               sector_neighborhood=(([]));
                               noninfected_time=((0))}
                          )
                    )
              )
        ) 
;;
let get_von_neumann_neighbors =
      (function
        | cell__val_rml_33  ->
            (function
              | cell_array__val_rml_34  ->
                  (let x__val_rml_35 = (cell__val_rml_33).cell_x  in
                    let y__val_rml_36 = (cell__val_rml_33).cell_y  in
                      let neighbors__val_rml_37 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_35 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_37
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_34
                                  (Pervasives.(-) x__val_rml_35 1))
                                y__val_rml_36))
                              :: (Pervasives.(!) neighbors__val_rml_37))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_35 1)
                              (Pervasives.(!) maxx)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_37
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_34
                                    (Pervasives.(+) x__val_rml_35 1))
                                  y__val_rml_36))
                                :: (Pervasives.(!) neighbors__val_rml_37))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_36 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_37
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_34 x__val_rml_35)
                                  (Pervasives.(-) y__val_rml_36 1)))
                                :: (Pervasives.(!) neighbors__val_rml_37))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_36 1)
                              (Pervasives.(!) maxy)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_37
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_34 x__val_rml_35)
                                  (Pervasives.(+) y__val_rml_36 1)))
                                :: (Pervasives.(!) neighbors__val_rml_37))
                            else ();
                          Pervasives.(!) neighbors__val_rml_37)
              )
        ) 
;;
let get_sector_neighbors =
      (function
        | sector__val_rml_39  ->
            (function
              | sector_array__val_rml_40  ->
                  (let (x__val_rml_41, y__val_rml_42) =
                         (sector__val_rml_39).coordinate
                     in
                    let neighbors__val_rml_43 = Pervasives.ref ([])  in
                      if Pervasives.(<=) (0) (Pervasives.(-) x__val_rml_41 1)
                        then
                        Pervasives.(:=)
                          neighbors__val_rml_43
                          ((Array.get
                             (Array.get
                               sector_array__val_rml_40
                               (Pervasives.(-) x__val_rml_41 1))
                             y__val_rml_42)
                            :: (Pervasives.(!) neighbors__val_rml_43))
                        else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) x__val_rml_41 1)
                            (Pervasives.(!) sectornumber)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_43
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_40
                                 (Pervasives.(+) x__val_rml_41 1))
                               y__val_rml_42)
                              :: (Pervasives.(!) neighbors__val_rml_43))
                          else ();
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) y__val_rml_42 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_43
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_40 x__val_rml_41)
                               (Pervasives.(-) y__val_rml_42 1))
                              :: (Pervasives.(!) neighbors__val_rml_43))
                          else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) y__val_rml_42 1)
                            (Pervasives.(!) sectornumber)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_43
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_40 x__val_rml_41)
                               (Pervasives.(+) y__val_rml_42 1))
                              :: (Pervasives.(!) neighbors__val_rml_43))
                          else ();
                        Pervasives.(!) neighbors__val_rml_43)
              )
        ) 
;;
let ebola =
      (function
        | cell__val_rml_45  ->
            (function
              | interactions__val_rml_46  ->
                  (let result__val_rml_47 = Pervasives.ref Susceptible  in
                    List.iter
                      (function
                        | info__val_rml_48  ->
                            (match info__val_rml_48 with
                             | {origin=Long_Lange;
                                status=Infectious; sector=_}  ->
                                 if
                                   Pervasives.(&&)
                                     (Pervasives.(=)
                                       (info__val_rml_48).sector
                                       (cell__val_rml_45).sector_id)
                                     (Pervasives.(<)
                                       (Random.float 1.) 0.0125)
                                   then
                                   Pervasives.(:=) result__val_rml_47 Exposed
                                   else
                                   if Pervasives.(<) (Random.float 1.) 0.0125
                                     then
                                     Pervasives.(:=)
                                       result__val_rml_47 Exposed
                                     else ()
                             | {origin=_; status=Infectious; sector=_}  ->
                                 if
                                   Pervasives.(&&)
                                     (Pervasives.(=)
                                       (info__val_rml_48).sector
                                       (cell__val_rml_45).sector_id)
                                     (Pervasives.(<) (Random.float 1.) 0.15)
                                   then
                                   Pervasives.(:=) result__val_rml_47 Exposed
                                   else
                                   if Pervasives.(<) (Random.float 1.) 0.15
                                     then
                                     Pervasives.(:=)
                                       result__val_rml_47 Exposed
                                     else ()
                             | {origin=_; status=_; sector=_}  -> () )
                        )
                      interactions__val_rml_46;
                      cell__val_rml_45.cell_status <-
                        (match (cell__val_rml_45).cell_status with
                         | Susceptible  ->
                             if
                               Pervasives.(=)
                                 (Pervasives.(!) result__val_rml_47) Exposed
                               then
                               (cell__val_rml_45.exposed_time <-
                                  (cell__val_rml_45).time;
                                 Exposed)
                               else Susceptible
                         | Exposed  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_45).time
                                   (cell__val_rml_45).exposed_time)
                                 delta
                               then Exposed else
                               (cell__val_rml_45.infectious_time <-
                                  (cell__val_rml_45).time;
                                 Infectious)
                         | Infectious  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_45).time
                                   (cell__val_rml_45).infectious_time)
                                 gamma
                               then Infectious else Removed
                         | Removed  -> Removed ))
              )
        ) 
;;
let post_ebola =
      (function
        | cell__val_rml_50  ->
            (function
              | interactions__val_rml_51  ->
                  (function
                    | sector_array__val_rml_52  ->
                        (let result__val_rml_53 = Pervasives.ref Susceptible 
                          in
                          List.iter
                            (function
                              | info__val_rml_54  ->
                                  (let (x__val_rml_55, y__val_rml_56) =
                                         (info__val_rml_54).sector
                                     in
                                    let sector__val_rml_57 =
                                          Array.get
                                            (Array.get
                                              sector_array__val_rml_52
                                              x__val_rml_55)
                                            y__val_rml_56
                                       in
                                      match (sector__val_rml_57).sector_status with
                                      | C  -> ()
                                      | _  ->
                                          (match info__val_rml_54 with
                                           | {origin=Long_Lange;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(&&)
                                                   (Pervasives.(=)
                                                     (info__val_rml_54).sector
                                                     (cell__val_rml_50).sector_id)
                                                   (Pervasives.(<)
                                                     (Random.float 1.) 0.0125)
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_53 Exposed
                                                 else
                                                 if
                                                   Pervasives.(<)
                                                     (Random.float 1.) 0.0125
                                                   then
                                                   Pervasives.(:=)
                                                     result__val_rml_53
                                                     Exposed
                                                   else ()
                                           | {origin=_;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(&&)
                                                   (Pervasives.(=)
                                                     (info__val_rml_54).sector
                                                     (cell__val_rml_50).sector_id)
                                                   (Pervasives.(<)
                                                     (Random.float 1.) 0.15)
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_53 Exposed
                                                 else
                                                 if
                                                   Pervasives.(<)
                                                     (Random.float 1.) 0.15
                                                   then
                                                   Pervasives.(:=)
                                                     result__val_rml_53
                                                     Exposed
                                                   else ()
                                           | {origin=_; status=_; sector=_}
                                                -> ()
                                           )
                                      )
                              )
                            interactions__val_rml_51;
                            cell__val_rml_50.cell_status <-
                              (match (cell__val_rml_50).cell_status with
                               | Susceptible  ->
                                   if
                                     Pervasives.(=)
                                       (Pervasives.(!) result__val_rml_53)
                                       Exposed
                                     then
                                     (cell__val_rml_50.exposed_time <-
                                        (cell__val_rml_50).time;
                                       Exposed)
                                     else Susceptible
                               | Exposed  ->
                                   if
                                     Pervasives.(<)
                                       (Pervasives.(-)
                                         (cell__val_rml_50).time
                                         (cell__val_rml_50).exposed_time)
                                       delta
                                     then Exposed else
                                     (cell__val_rml_50.infectious_time <-
                                        (cell__val_rml_50).time;
                                       Infectious)
                               | Infectious  ->
                                   if
                                     Pervasives.(<)
                                       (Pervasives.(-)
                                         (cell__val_rml_50).time
                                         (cell__val_rml_50).infectious_time)
                                       gamma
                                     then Infectious else Removed
                               | Removed  -> Removed ))
                    )
              )
        ) 
;;
let isolated =
      (function
        | cell__val_rml_59  ->
            cell__val_rml_59.cell_status <-
              (match (cell__val_rml_59).cell_status with
               | Susceptible  -> Susceptible
               | Exposed  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_59).time
                         (cell__val_rml_59).exposed_time)
                       delta
                     then Exposed else
                     (cell__val_rml_59.infectious_time <-
                        (cell__val_rml_59).time;
                       Infectious)
               | Infectious  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_59).time
                         (cell__val_rml_59).infectious_time)
                       gamma
                     then Infectious else Removed
               | Removed  -> Removed )
        ) 
;;
let rec activate_sector_neighborhood =
          (function
            | self__val_rml_61  ->
                (function
                  | neighbors__val_rml_62  ->
                      (match neighbors__val_rml_62 with | ([])  -> ()
                       | (sector__val_rml_63) :: (neighbors'__val_rml_64)  ->
                           (let info__val_rml_65 =
                                  (self__val_rml_61).sector_status
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (sector__val_rml_63).sector_activation
                               info__val_rml_65;
                               activate_sector_neighborhood
                                 self__val_rml_61 neighbors'__val_rml_64)
                       )
                  )
            ) 
;;
let sector =
      (function
        | coordinate__val_rml_67  ->
            (function
              | sector_array__val_rml_68  ->
                  ((function
                     | ()  ->
                         Lco_ctrl_tree_record.rml_signal
                           (function
                             | sector_presence__sig_69  ->
                                 Lco_ctrl_tree_record.rml_signal
                                   (function
                                     | sector_activation__sig_70  ->
                                         (let (x__val_rml_71, y__val_rml_72)
                                                = coordinate__val_rml_67
                                            in
                                           Lco_ctrl_tree_record.rml_def
                                             (function
                                               | ()  ->
                                                   new_sector
                                                     A
                                                     sector_presence__sig_69
                                                     sector_activation__sig_70
                                                     coordinate__val_rml_67
                                               )
                                             (function
                                               | self_sector__val_rml_73  ->
                                                   Lco_ctrl_tree_record.rml_seq
                                                     (Lco_ctrl_tree_record.rml_seq
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 Array.set
                                                                   (Array.get
                                                                    sector_array__val_rml_68
                                                                    x__val_rml_71)
                                                                   y__val_rml_72
                                                                   self_sector__val_rml_73
                                                             ))
                                                         Lco_ctrl_tree_record.rml_pause)
                                                       (Lco_ctrl_tree_record.rml_compute
                                                         (function
                                                           | ()  ->
                                                               self_sector__val_rml_73.sector_neighborhood
                                                                 <-
                                                                 get_sector_neighbors
                                                                   self_sector__val_rml_73
                                                                   sector_array__val_rml_68
                                                           )))
                                                     (Lco_ctrl_tree_record.rml_loop
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_seq
                                                           (Lco_ctrl_tree_record.rml_compute
                                                             (function
                                                               | ()  ->
                                                                   activate_sector_neighborhood
                                                                    self_sector__val_rml_73
                                                                    (self_sector__val_rml_73).sector_neighborhood
                                                               ))
                                                           Lco_ctrl_tree_record.rml_pause)
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 (let 
                                                                   sector_reports__val_rml_74
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_activation__sig_70
                                                                    in
                                                                   if
                                                                    Pervasives.(!=)
                                                                    (self_sector__val_rml_73).sector_status
                                                                    C then
                                                                    (let 
                                                                    cell_reports__val_rml_75
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_presence__sig_69
                                                                     in
                                                                    match 
                                                                    cell_reports__val_rml_75 with
                                                                    | 
                                                                    ([])  ->
                                                                    if
                                                                    Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (self_sector__val_rml_73).noninfected_time
                                                                    (Pervasives.(+)
                                                                    delta 1))
                                                                    (List.mem
                                                                    A
                                                                    sector_reports__val_rml_74)
                                                                    then
                                                                    self_sector__val_rml_73.sector_status
                                                                    <- 
                                                                    C else
                                                                    self_sector__val_rml_73.sector_status
                                                                    <- 
                                                                    B;
                                                                    self_sector__val_rml_73.noninfected_time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self_sector__val_rml_73).noninfected_time
                                                                    1
                                                                    | 
                                                                    _  ->
                                                                    self_sector__val_rml_73.sector_status
                                                                    <- 
                                                                    A;
                                                                    self_sector__val_rml_73.noninfected_time
                                                                    <- 
                                                                    (0) )
                                                                    else 
                                                                    ())
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
            | self__val_rml_77  ->
                (function
                  | neighbors__val_rml_78  ->
                      (match neighbors__val_rml_78 with | ([])  -> ()
                       | ((dir__val_rml_79, cell__val_rml_80)) ::
                           (neighbors'__val_rml_81)  ->
                           (let info__val_rml_82 =
                                  make_info
                                    (opposite dir__val_rml_79)
                                    self__val_rml_77
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (cell__val_rml_80).cell_activation
                               info__val_rml_82;
                               activate_neighborhood
                                 self__val_rml_77 neighbors'__val_rml_81)
                       )
                  )
            ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_84  ->
                (function
                  | cell_array__val_rml_85  ->
                      (let maxx__val_rml_86 = Pervasives.(!) maxx  in
                        let maxy__val_rml_87 = Pervasives.(!) maxy  in
                          let x__val_rml_88 = (cell__val_rml_84).cell_x  in
                            let y__val_rml_89 = (cell__val_rml_84).cell_y  in
                              let rand_x__val_rml_90 =
                                    Random.int maxx__val_rml_86
                                 in
                                let rand_y__val_rml_91 =
                                      Random.int maxy__val_rml_87
                                   in
                                  if
                                    Pervasives.(&&)
                                      (Pervasives.(<>)
                                        x__val_rml_88 rand_x__val_rml_90)
                                      (Pervasives.(<>)
                                        y__val_rml_89 rand_y__val_rml_91)
                                    then
                                    (let other__val_rml_92 =
                                           Array.get
                                             (Array.get
                                               cell_array__val_rml_85
                                               rand_x__val_rml_90)
                                             rand_y__val_rml_91
                                       in
                                      let other_activation__val_rml_93 =
                                            (other__val_rml_92).cell_activation
                                         in
                                        Lco_ctrl_tree_record.rml_expr_emit_val
                                          (cell__val_rml_84).cell_activation
                                          (make_info
                                            Long_Lange other__val_rml_92);
                                          Lco_ctrl_tree_record.rml_expr_emit_val
                                            other_activation__val_rml_93
                                            (make_info
                                              Long_Lange cell__val_rml_84))
                                    else
                                    long_range_interaction
                                      cell__val_rml_84 cell_array__val_rml_85)
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_95  ->
            (function
              | get_neighbors__val_rml_96  ->
                  (function
                    | x__val_rml_97  ->
                        (function
                          | y__val_rml_98  ->
                              (function
                                | status_init__val_rml_99  ->
                                    (function
                                      | cell_array__val_rml_100  ->
                                          (function
                                            | sector_array__val_rml_101  ->
                                                ((function
                                                   | ()  ->
                                                       Lco_ctrl_tree_record.rml_signal
                                                         (function
                                                           | activation__sig_102
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    ((Pervasives.(/)
                                                                    x__val_rml_97
                                                                    (Pervasives.(!)
                                                                    sectormaxx)),
                                                                    (Pervasives.(/)
                                                                    y__val_rml_98
                                                                    (Pervasives.(!)
                                                                    sectormaxy)))
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_id__val_rml_103
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    new_cell
                                                                    x__val_rml_97
                                                                    y__val_rml_98
                                                                    activation__sig_102
                                                                    status_init__val_rml_99
                                                                    sector_id__val_rml_103
                                                                    )
                                                                    (function
                                                                    | self__val_rml_104
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_100
                                                                    x__val_rml_97)
                                                                    y__val_rml_98
                                                                    self__val_rml_104;
                                                                    draw_cell__val_rml_95
                                                                    self__val_rml_104
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_104.cell_neighborhood
                                                                    <-
                                                                    get_neighbors__val_rml_96
                                                                    self__val_rml_104
                                                                    cell_array__val_rml_100
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    long_range_interaction
                                                                    self__val_rml_104
                                                                    cell_array__val_rml_100;
                                                                    activate_neighborhood
                                                                    self__val_rml_104
                                                                    (self__val_rml_104).cell_neighborhood
                                                                    ))
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    Array.get
                                                                    (Array.get
                                                                    sector_array__val_rml_101
                                                                    (Pervasives.fst
                                                                    sector_id__val_rml_103))
                                                                    (Pervasives.snd
                                                                    sector_id__val_rml_103)
                                                                    )
                                                                    (function
                                                                    | sector__val_rml_105
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    if
                                                                    Pervasives.(=)
                                                                    (self__val_rml_104).cell_status
                                                                    Infectious
                                                                    then
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    (sector__val_rml_105).sector_presence
                                                                    (self__val_rml_104).cell_status
                                                                    else 
                                                                    () ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    (let 
                                                                    interactions__val_rml_106
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_102
                                                                     in
                                                                    if
                                                                    Pervasives.(<)
                                                                    (self__val_rml_104).time
                                                                    (Pervasives.(!)
                                                                    tzero)
                                                                    then
                                                                    ebola
                                                                    self__val_rml_104
                                                                    interactions__val_rml_106
                                                                    else
                                                                    if
                                                                    Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (Pervasives.(-)
                                                                    (self__val_rml_104).time
                                                                    (self__val_rml_104).infectious_time)
                                                                    1)
                                                                    (self__val_rml_104).compliant
                                                                    then
                                                                    isolated
                                                                    self__val_rml_104
                                                                    else
                                                                    post_ebola
                                                                    self__val_rml_104
                                                                    interactions__val_rml_106
                                                                    sector_array__val_rml_101;
                                                                    draw_cell__val_rml_95
                                                                    self__val_rml_104;
                                                                    self__val_rml_104.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_104).time
                                                                    1) )) ))))
                                                                    )
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
        | tmp__val_rml_108  ->
            Array.make_matrix
              (Pervasives.(!) maxx) (Pervasives.(!) maxy) tmp__val_rml_108
        ) 
;;
let sector_array_create =
      (function
        | tmp__val_rml_110  ->
            Array.make_matrix
              (Pervasives.(!) sectornumber)
              (Pervasives.(!) sectornumber) tmp__val_rml_110
        ) 
;;
let get_status =
      (function
        | i__val_rml_112  ->
            (function
              | j__val_rml_113  ->
                  if Pervasives.(<) (Random.float 1.) 0.0002 then Infectious
                    else
                    if Pervasives.(<) (Random.float 1.) 0.0002 then Exposed
                      else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_115  ->
            (function
              | get_neighbors__val_rml_116  ->
                  (function
                    | get_status__val_rml_117  ->
                        (function
                          | cell_array__val_rml_118  ->
                              (function
                                | sector_array__val_rml_119  ->
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
                                               | i__val_rml_120  ->
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
                                                       | j__val_rml_121  ->
                                                           Lco_ctrl_tree_record.rml_if
                                                             (function
                                                               | ()  ->
                                                                   Pervasives.(&&)
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    j__val_rml_121
                                                                    (Pervasives.(!)
                                                                    sectormaxx))
                                                                    (0))
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    i__val_rml_120
                                                                    (Pervasives.(!)
                                                                    sectormaxy))
                                                                    (0))
                                                               )
                                                             (Lco_ctrl_tree_record.rml_par
                                                               (Lco_ctrl_tree_record.rml_run
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_115
                                                                    get_neighbors__val_rml_116
                                                                    i__val_rml_120
                                                                    j__val_rml_121
                                                                    (get_status__val_rml_117
                                                                    i__val_rml_120
                                                                    j__val_rml_121)
                                                                    cell_array__val_rml_118
                                                                    sector_array__val_rml_119
                                                                   ))
                                                               (Lco_ctrl_tree_record.rml_run
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    sector
                                                                    ((Pervasives.(/)
                                                                    i__val_rml_120
                                                                    (Pervasives.(!)
                                                                    sectormaxx)),
                                                                    (Pervasives.(/)
                                                                    j__val_rml_121
                                                                    (Pervasives.(!)
                                                                    sectormaxy)))
                                                                    sector_array__val_rml_119
                                                                   )))
                                                             (Lco_ctrl_tree_record.rml_run
                                                               (function
                                                                 | ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_115
                                                                    get_neighbors__val_rml_116
                                                                    i__val_rml_120
                                                                    j__val_rml_121
                                                                    (get_status__val_rml_117
                                                                    i__val_rml_120
                                                                    j__val_rml_121)
                                                                    cell_array__val_rml_118
                                                                    sector_array__val_rml_119
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
                   | tmp_cell__sig_123  ->
                       Lco_ctrl_tree_record.rml_signal
                         (function
                           | tmp_sector_p__sig_124  ->
                               Lco_ctrl_tree_record.rml_signal
                                 (function
                                   | tmp_sector_a__sig_125  ->
                                       Lco_ctrl_tree_record.rml_def
                                         (function
                                           | ()  ->
                                               new_cell
                                                 5
                                                 5
                                                 tmp_cell__sig_123
                                                 Susceptible ((0), (0))
                                           )
                                         (function
                                           | dummy_cell__val_rml_126  ->
                                               Lco_ctrl_tree_record.rml_def
                                                 (function
                                                   | ()  ->
                                                       new_sector
                                                         C
                                                         tmp_sector_p__sig_124
                                                         tmp_sector_a__sig_125
                                                         ((0), (0))
                                                   )
                                                 (function
                                                   | dummy_sector__val_rml_127
                                                        ->
                                                       Lco_ctrl_tree_record.rml_def
                                                         (function
                                                           | ()  ->
                                                               cell_array_create
                                                                 dummy_cell__val_rml_126
                                                           )
                                                         (function
                                                           | cell_array__val_rml_128
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    sector_array_create
                                                                    dummy_sector__val_rml_127
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_array__val_rml_129
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    draw_cell_gen
                                                                    color_of_status
                                                                    )
                                                                    (function
                                                                    | draw__val_rml_130
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_par
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cellular_automaton_start
                                                                    draw__val_rml_130
                                                                    get_von_neumann_neighbors
                                                                    get_status
                                                                    cell_array__val_rml_128
                                                                    sector_array__val_rml_129
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
