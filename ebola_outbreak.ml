(* THIS FILE IS GENERATED. *)
(* rmlc -dtypes -n -1 -sampling -1.0 ebola_outbreak.rml  *)

open Implem_lco_ctrl_tree_record;;
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
let maxx = 200 
;;
let maxy = 200 
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
let t0 = 30 
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
        | status__val_rml_23  ->
            (function
              | presence__val_rml_24  ->
                  (function
                    | activation__val_rml_25  ->
                        (function
                          | coordinate__val_rml_26  ->
                              {sector_status=(status__val_rml_23);
                               sector_presence=(presence__val_rml_24);
                               sector_activation=(activation__val_rml_25);
                               coordinate=(coordinate__val_rml_26);
                               sector_neighborhood=(([]));
                               noninfected_time=((0)); sector_time=((0))}
                          )
                    )
              )
        ) 
;;
let line_color =
      (function
        | sector_status__val_rml_28  ->
            (match sector_status__val_rml_28 with | A  -> Graphics.red
             | B  -> Graphics.yellow | C  -> Graphics.blue )
        ) 
;;
let draw_cell_gen =
      (function
        | color_of_cell__val_rml_30  ->
            (function
              | c__val_rml_31  ->
                  (function
                    | sector_array__val_rml_32  ->
                        Graphics.set_color
                          (color_of_cell__val_rml_30 c__val_rml_31);
                          Graphics.fill_rect
                            (Pervasives.( * ) (c__val_rml_31).cell_x zoom)
                            (Pervasives.( * ) (c__val_rml_31).cell_y zoom)
                            zoom zoom;
                          (let (x__val_rml_33, y__val_rml_34) =
                                 (c__val_rml_31).sector_id
                             in
                            let sector__val_rml_35 =
                                  Array.get
                                    (Array.get
                                      sector_array__val_rml_32 x__val_rml_33)
                                    y__val_rml_34
                               in
                              let color__val_rml_36 =
                                    if
                                      Pervasives.(<)
                                        (c__val_rml_31).time
                                        (Pervasives.(+) t0 gamma)
                                      then Graphics.black else
                                      line_color
                                        (sector__val_rml_35).sector_status
                                 in
                                Graphics.set_color color__val_rml_36;
                                  Graphics.moveto
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_x zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_y zoom);
                                  Graphics.lineto
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_x zoom)
                                    (Pervasives.( * )
                                      (Pervasives.(+)
                                        (c__val_rml_31).cell_y 1)
                                      zoom);
                                  Graphics.moveto
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_x zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_y zoom);
                                  Graphics.lineto
                                    (Pervasives.( * )
                                      (Pervasives.(+)
                                        (c__val_rml_31).cell_x 1)
                                      zoom)
                                    (Pervasives.( * )
                                      (c__val_rml_31).cell_y zoom);
                                  if
                                    Pervasives.(=)
                                      (Pervasives.(mod)
                                        (c__val_rml_31).cell_x sectormaxx)
                                      (0)
                                    then
                                    (Graphics.set_color Graphics.black;
                                       Graphics.moveto
                                         (Pervasives.( * )
                                           (c__val_rml_31).cell_x zoom)
                                         (Pervasives.( * )
                                           (c__val_rml_31).cell_y zoom);
                                      Graphics.lineto
                                        (Pervasives.( * )
                                          (c__val_rml_31).cell_x zoom)
                                        (Pervasives.( * )
                                          (Pervasives.(+)
                                            (c__val_rml_31).cell_y 1)
                                          zoom))
                                    else
                                    if
                                      Pervasives.(=)
                                        (Pervasives.(mod)
                                          (c__val_rml_31).cell_y sectormaxy)
                                        (0)
                                      then
                                      (Graphics.set_color Graphics.black;
                                         Graphics.moveto
                                           (Pervasives.( * )
                                             (c__val_rml_31).cell_x zoom)
                                           (Pervasives.( * )
                                             (c__val_rml_31).cell_y zoom);
                                        Graphics.lineto
                                          (Pervasives.( * )
                                            (Pervasives.(+)
                                              (c__val_rml_31).cell_x 1)
                                            zoom)
                                          (Pervasives.( * )
                                            (c__val_rml_31).cell_y zoom))
                                      else ())
                    )
              )
        ) 
;;
let color_of_status =
      (function
        | s__val_rml_38  ->
            (match (s__val_rml_38).cell_status with
             | Susceptible  -> Graphics.rgb 102 102 102
             | Exposed  -> Graphics.yellow | Infectious  -> Graphics.red
             | Removed  -> Graphics.black )
        ) 
;;
let get_von_neumann_neighbors =
      (function
        | cell__val_rml_40  ->
            (function
              | cell_array__val_rml_41  ->
                  (let x__val_rml_42 = (cell__val_rml_40).cell_x  in
                    let y__val_rml_43 = (cell__val_rml_40).cell_y  in
                      let neighbors__val_rml_44 = Pervasives.ref ([])  in
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) x__val_rml_42 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_44
                            ((Left,
                              (Array.get
                                (Array.get
                                  cell_array__val_rml_41
                                  (Pervasives.(-) x__val_rml_42 1))
                                y__val_rml_43))
                              :: (Pervasives.(!) neighbors__val_rml_44))
                          else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) x__val_rml_42 1) maxx
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_44
                              ((Right,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_41
                                    (Pervasives.(+) x__val_rml_42 1))
                                  y__val_rml_43))
                                :: (Pervasives.(!) neighbors__val_rml_44))
                            else ();
                          if
                            Pervasives.(<=)
                              (0) (Pervasives.(-) y__val_rml_43 1)
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_44
                              ((Down,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_41 x__val_rml_42)
                                  (Pervasives.(-) y__val_rml_43 1)))
                                :: (Pervasives.(!) neighbors__val_rml_44))
                            else ();
                          if
                            Pervasives.(<)
                              (Pervasives.(+) y__val_rml_43 1) maxy
                            then
                            Pervasives.(:=)
                              neighbors__val_rml_44
                              ((Up,
                                (Array.get
                                  (Array.get
                                    cell_array__val_rml_41 x__val_rml_42)
                                  (Pervasives.(+) y__val_rml_43 1)))
                                :: (Pervasives.(!) neighbors__val_rml_44))
                            else ();
                          Pervasives.(!) neighbors__val_rml_44)
              )
        ) 
;;
let get_sector_neighbors =
      (function
        | sector__val_rml_46  ->
            (function
              | sector_array__val_rml_47  ->
                  (let (x__val_rml_48, y__val_rml_49) =
                         (sector__val_rml_46).coordinate
                     in
                    let neighbors__val_rml_50 = Pervasives.ref ([])  in
                      if Pervasives.(<=) (0) (Pervasives.(-) x__val_rml_48 1)
                        then
                        Pervasives.(:=)
                          neighbors__val_rml_50
                          ((Array.get
                             (Array.get
                               sector_array__val_rml_47
                               (Pervasives.(-) x__val_rml_48 1))
                             y__val_rml_49)
                            :: (Pervasives.(!) neighbors__val_rml_50))
                        else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) x__val_rml_48 1) sector_number
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_50
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_47
                                 (Pervasives.(+) x__val_rml_48 1))
                               y__val_rml_49)
                              :: (Pervasives.(!) neighbors__val_rml_50))
                          else ();
                        if
                          Pervasives.(<=)
                            (0) (Pervasives.(-) y__val_rml_49 1)
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_50
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_47 x__val_rml_48)
                               (Pervasives.(-) y__val_rml_49 1))
                              :: (Pervasives.(!) neighbors__val_rml_50))
                          else ();
                        if
                          Pervasives.(<)
                            (Pervasives.(+) y__val_rml_49 1) sector_number
                          then
                          Pervasives.(:=)
                            neighbors__val_rml_50
                            ((Array.get
                               (Array.get
                                 sector_array__val_rml_47 x__val_rml_48)
                               (Pervasives.(+) y__val_rml_49 1))
                              :: (Pervasives.(!) neighbors__val_rml_50))
                          else ();
                        Pervasives.(!) neighbors__val_rml_50)
              )
        ) 
;;
let ebola =
      (function
        | cell__val_rml_52  ->
            (function
              | interactions__val_rml_53  ->
                  (let result__val_rml_54 = Pervasives.ref Susceptible  in
                    List.iter
                      (function
                        | info__val_rml_55  ->
                            (match info__val_rml_55 with
                             | {origin=Long_Range;
                                status=Infectious; sector=_}  ->
                                 if Pervasives.(<) (Random.float 1.) 0.015
                                   then
                                   Pervasives.(:=) result__val_rml_54 Exposed
                                   else ()
                             | {origin=_; status=Infectious; sector=_}  ->
                                 if Pervasives.(<) (Random.float 1.) 0.18
                                   then
                                   Pervasives.(:=) result__val_rml_54 Exposed
                                   else ()
                             | {origin=_; status=_; sector=_}  -> () )
                        )
                      interactions__val_rml_53;
                      cell__val_rml_52.cell_status <-
                        (match (cell__val_rml_52).cell_status with
                         | Susceptible  ->
                             if
                               Pervasives.(=)
                                 (Pervasives.(!) result__val_rml_54) Exposed
                               then
                               (cell__val_rml_52.exposed_time <-
                                  (cell__val_rml_52).time;
                                 Exposed)
                               else Susceptible
                         | Exposed  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_52).time
                                   (cell__val_rml_52).exposed_time)
                                 delta
                               then Exposed else
                               (cell__val_rml_52.infectious_time <-
                                  (cell__val_rml_52).time;
                                 Infectious)
                         | Infectious  ->
                             if
                               Pervasives.(<)
                                 (Pervasives.(-)
                                   (cell__val_rml_52).time
                                   (cell__val_rml_52).infectious_time)
                                 gamma
                               then Infectious else Removed
                         | Removed  -> Removed ))
              )
        ) 
;;
let post_ebola =
      (function
        | cell__val_rml_57  ->
            (function
              | interactions__val_rml_58  ->
                  (function
                    | sector_array__val_rml_59  ->
                        (let result__val_rml_60 = Pervasives.ref Susceptible 
                          in
                          List.iter
                            (function
                              | info__val_rml_61  ->
                                  (let (x__val_rml_62, y__val_rml_63) =
                                         (info__val_rml_61).sector
                                     in
                                    let sector__val_rml_64 =
                                          Array.get
                                            (Array.get
                                              sector_array__val_rml_59
                                              x__val_rml_62)
                                            y__val_rml_63
                                       in
                                      match (sector__val_rml_64).sector_status with
                                      | C  -> ()
                                      | _  ->
                                          (match info__val_rml_61 with
                                           | {origin=Long_Range;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(<)
                                                   (Random.float 1.) 0.015
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_60 Exposed
                                                 else ()
                                           | {origin=_;
                                              status=Infectious; sector=_}
                                                ->
                                               if
                                                 Pervasives.(<)
                                                   (Random.float 1.) 0.18
                                                 then
                                                 Pervasives.(:=)
                                                   result__val_rml_60 Exposed
                                                 else ()
                                           | {origin=_; status=_; sector=_}
                                                -> ()
                                           )
                                      )
                              )
                            interactions__val_rml_58;
                            cell__val_rml_57.cell_status <-
                              (match (cell__val_rml_57).cell_status with
                               | Susceptible  ->
                                   if
                                     Pervasives.(=)
                                       (Pervasives.(!) result__val_rml_60)
                                       Exposed
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
        ) 
;;
let isolated =
      (function
        | cell__val_rml_66  ->
            cell__val_rml_66.cell_status <-
              (match (cell__val_rml_66).cell_status with
               | Susceptible  -> Susceptible
               | Exposed  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_66).time
                         (cell__val_rml_66).exposed_time)
                       delta
                     then Exposed else
                     (cell__val_rml_66.infectious_time <-
                        (cell__val_rml_66).time;
                       Infectious)
               | Infectious  ->
                   if
                     Pervasives.(<)
                       (Pervasives.(-)
                         (cell__val_rml_66).time
                         (cell__val_rml_66).infectious_time)
                       gamma
                     then Infectious else Removed
               | Removed  -> Removed )
        ) 
;;
let rec activate_sector_neighborhood =
          (function
            | self__val_rml_68  ->
                (function
                  | neighbors__val_rml_69  ->
                      (match neighbors__val_rml_69 with | ([])  -> ()
                       | (sector__val_rml_70) :: (neighbors'__val_rml_71)  ->
                           (let info__val_rml_72 =
                                  (self__val_rml_68).sector_status
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (sector__val_rml_70).sector_activation
                               info__val_rml_72;
                               activate_sector_neighborhood
                                 self__val_rml_68 neighbors'__val_rml_71)
                       )
                  )
            ) 
;;
let sector =
      (function
        | coordinate__val_rml_74  ->
            (function
              | sector_array__val_rml_75  ->
                  ((function
                     | ()  ->
                         Lco_ctrl_tree_record.rml_signal
                           (function
                             | sector_presence__sig_76  ->
                                 Lco_ctrl_tree_record.rml_signal
                                   (function
                                     | sector_activation__sig_77  ->
                                         (let (x__val_rml_78, y__val_rml_79)
                                                = coordinate__val_rml_74
                                            in
                                           Lco_ctrl_tree_record.rml_def
                                             (function
                                               | ()  ->
                                                   new_sector
                                                     A
                                                     sector_presence__sig_76
                                                     sector_activation__sig_77
                                                     coordinate__val_rml_74
                                               )
                                             (function
                                               | self_sector__val_rml_80  ->
                                                   Lco_ctrl_tree_record.rml_seq
                                                     (Lco_ctrl_tree_record.rml_seq
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 Array.set
                                                                   (Array.get
                                                                    sector_array__val_rml_75
                                                                    x__val_rml_78)
                                                                   y__val_rml_79
                                                                   self_sector__val_rml_80
                                                             ))
                                                         Lco_ctrl_tree_record.rml_pause)
                                                       (Lco_ctrl_tree_record.rml_compute
                                                         (function
                                                           | ()  ->
                                                               self_sector__val_rml_80.sector_neighborhood
                                                                 <-
                                                                 get_sector_neighbors
                                                                   self_sector__val_rml_80
                                                                   sector_array__val_rml_75
                                                           )))
                                                     (Lco_ctrl_tree_record.rml_loop
                                                       (Lco_ctrl_tree_record.rml_seq
                                                         (Lco_ctrl_tree_record.rml_seq
                                                           (Lco_ctrl_tree_record.rml_compute
                                                             (function
                                                               | ()  ->
                                                                   activate_sector_neighborhood
                                                                    self_sector__val_rml_80
                                                                    (self_sector__val_rml_80).sector_neighborhood
                                                               ))
                                                           Lco_ctrl_tree_record.rml_pause)
                                                         (Lco_ctrl_tree_record.rml_compute
                                                           (function
                                                             | ()  ->
                                                                 (let 
                                                                   sector_reports__val_rml_81
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_activation__sig_77
                                                                    in
                                                                   if
                                                                    Pervasives.(>)
                                                                    (self_sector__val_rml_80).sector_time
                                                                    (Pervasives.(+)
                                                                    t0 gamma)
                                                                    then
                                                                    if
                                                                    Pervasives.(!=)
                                                                    (self_sector__val_rml_80).sector_status
                                                                    C then
                                                                    (let 
                                                                    cell_reports__val_rml_82
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    sector_presence__sig_76
                                                                     in
                                                                    match 
                                                                    cell_reports__val_rml_82 with
                                                                    | 
                                                                    ([])  ->
                                                                    if
                                                                    Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (self_sector__val_rml_80).noninfected_time
                                                                    (Pervasives.(+)
                                                                    gamma 1))
                                                                    (Pervasives.not
                                                                    (List.mem
                                                                    A
                                                                    sector_reports__val_rml_81))
                                                                    then
                                                                    self_sector__val_rml_80.sector_status
                                                                    <- 
                                                                    C else
                                                                    self_sector__val_rml_80.sector_status
                                                                    <- 
                                                                    B;
                                                                    self_sector__val_rml_80.noninfected_time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self_sector__val_rml_80).noninfected_time
                                                                    1
                                                                    | 
                                                                    _  ->
                                                                    self_sector__val_rml_80.sector_status
                                                                    <- 
                                                                    A;
                                                                    self_sector__val_rml_80.noninfected_time
                                                                    <- 
                                                                    (0) )
                                                                    else 
                                                                    () else
                                                                    ();
                                                                    self_sector__val_rml_80.sector_time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self_sector__val_rml_80).sector_time
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
            | self__val_rml_84  ->
                (function
                  | neighbors__val_rml_85  ->
                      (match neighbors__val_rml_85 with | ([])  -> ()
                       | ((dir__val_rml_86, cell__val_rml_87)) ::
                           (neighbors'__val_rml_88)  ->
                           (let info__val_rml_89 =
                                  make_info
                                    (opposite dir__val_rml_86)
                                    self__val_rml_84
                              in
                             Lco_ctrl_tree_record.rml_expr_emit_val
                               (cell__val_rml_87).cell_activation
                               info__val_rml_89;
                               activate_neighborhood
                                 self__val_rml_84 neighbors'__val_rml_88)
                       )
                  )
            ) 
;;
let get_sector_status =
      (function
        | cell__val_rml_91  ->
            (function
              | sector_array__val_rml_92  ->
                  (let (x__val_rml_93, y__val_rml_94) =
                         (cell__val_rml_91).sector_id
                     in
                    let own_sector__val_rml_95 =
                          (Array.get
                            (Array.get
                              sector_array__val_rml_92 x__val_rml_93)
                            y__val_rml_94).sector_status
                       in own_sector__val_rml_95)
              )
        ) 
;;
let rec long_range_interaction =
          (function
            | cell__val_rml_97  ->
                (function
                  | cell_array__val_rml_98  ->
                      (function
                        | sector_array__val_rml_99  ->
                            (let x__val_rml_102 = (cell__val_rml_97).cell_x 
                              in
                              let y__val_rml_103 = (cell__val_rml_97).cell_y 
                                in
                                let rand_x__val_rml_104 = Random.int maxx  in
                                  let rand_y__val_rml_105 = Random.int maxy 
                                    in
                                    if
                                      Pervasives.(&&)
                                        (Pervasives.(<>)
                                          x__val_rml_102 rand_x__val_rml_104)
                                        (Pervasives.(<>)
                                          y__val_rml_103 rand_y__val_rml_105)
                                      then
                                      (let other__val_rml_106 =
                                             Array.get
                                               (Array.get
                                                 cell_array__val_rml_98
                                                 rand_x__val_rml_104)
                                               rand_y__val_rml_105
                                         in
                                        if
                                          Pervasives.(=)
                                            (get_sector_status
                                              other__val_rml_106
                                              sector_array__val_rml_99)
                                            C
                                          then () else
                                          (let other_activation__val_rml_107
                                                 =
                                                 (other__val_rml_106).cell_activation
                                             in
                                            Lco_ctrl_tree_record.rml_expr_emit_val
                                              (cell__val_rml_97).cell_activation
                                              (make_info
                                                Long_Range other__val_rml_106);
                                              Lco_ctrl_tree_record.rml_expr_emit_val
                                                other_activation__val_rml_107
                                                (make_info
                                                  Long_Range cell__val_rml_97)))
                                      else
                                      long_range_interaction
                                        cell__val_rml_97
                                        cell_array__val_rml_98
                                        sector_array__val_rml_99)
                        )
                  )
            ) 
;;
let cell =
      (function
        | draw_cell__val_rml_109  ->
            (function
              | get_neighbors__val_rml_110  ->
                  (function
                    | x__val_rml_111  ->
                        (function
                          | y__val_rml_112  ->
                              (function
                                | status_init__val_rml_113  ->
                                    (function
                                      | cell_array__val_rml_114  ->
                                          (function
                                            | sector_array__val_rml_115  ->
                                                ((function
                                                   | ()  ->
                                                       Lco_ctrl_tree_record.rml_signal
                                                         (function
                                                           | activation__sig_116
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    ((Pervasives.(/)
                                                                    x__val_rml_111
                                                                    sectormaxx),
                                                                    (Pervasives.(/)
                                                                    y__val_rml_112
                                                                    sectormaxy))
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_id__val_rml_117
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    new_cell
                                                                    x__val_rml_111
                                                                    y__val_rml_112
                                                                    activation__sig_116
                                                                    status_init__val_rml_113
                                                                    sector_id__val_rml_117
                                                                    )
                                                                    (function
                                                                    | self__val_rml_118
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    Array.set
                                                                    (Array.get
                                                                    cell_array__val_rml_114
                                                                    x__val_rml_111)
                                                                    y__val_rml_112
                                                                    self__val_rml_118;
                                                                    draw_cell__val_rml_109
                                                                    self__val_rml_118
                                                                    ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    self__val_rml_118.cell_neighborhood
                                                                    <-
                                                                    get_neighbors__val_rml_110
                                                                    self__val_rml_118
                                                                    cell_array__val_rml_114
                                                                    )))
                                                                    (Lco_ctrl_tree_record.rml_loop
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    get_sector_status
                                                                    self__val_rml_118
                                                                    sector_array__val_rml_115
                                                                    )
                                                                    (function
                                                                    | own_sector__val_rml_119
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
                                                                    (self__val_rml_118).time
                                                                    (self__val_rml_118).infectious_time)
                                                                    1)
                                                                    (self__val_rml_118).compliant)
                                                                    (Pervasives.(=)
                                                                    own_sector__val_rml_119
                                                                    C) then
                                                                    () else
                                                                    (long_range_interaction
                                                                    self__val_rml_118
                                                                    cell_array__val_rml_114
                                                                    sector_array__val_rml_115;
                                                                    activate_neighborhood
                                                                    self__val_rml_118
                                                                    (self__val_rml_118).cell_neighborhood)
                                                                    ))
                                                                    (Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    Array.get
                                                                    (Array.get
                                                                    sector_array__val_rml_115
                                                                    (Pervasives.fst
                                                                    sector_id__val_rml_117))
                                                                    (Pervasives.snd
                                                                    sector_id__val_rml_117)
                                                                    )
                                                                    (function
                                                                    | sector__val_rml_120
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_seq
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    if
                                                                    Pervasives.(=)
                                                                    (self__val_rml_118).cell_status
                                                                    Infectious
                                                                    then
                                                                    Lco_ctrl_tree_record.rml_expr_emit_val
                                                                    (sector__val_rml_120).sector_presence
                                                                    (self__val_rml_118).cell_status
                                                                    else 
                                                                    () ))
                                                                    Lco_ctrl_tree_record.rml_pause)
                                                                    (Lco_ctrl_tree_record.rml_compute
                                                                    (function
                                                                    | ()  ->
                                                                    draw_cell__val_rml_109
                                                                    self__val_rml_118
                                                                    sector_array__val_rml_115;
                                                                    (let 
                                                                    own_sector__val_rml_121
                                                                    =
                                                                    get_sector_status
                                                                    self__val_rml_118
                                                                    sector_array__val_rml_115
                                                                     in
                                                                    let 
                                                                    interactions__val_rml_122
                                                                    =
                                                                    Lco_ctrl_tree_record.rml_pre_value
                                                                    activation__sig_116
                                                                     in
                                                                    if
                                                                    Pervasives.(<)
                                                                    (self__val_rml_118).time
                                                                    t0 then
                                                                    ebola
                                                                    self__val_rml_118
                                                                    interactions__val_rml_122
                                                                    else
                                                                    if
                                                                    Pervasives.(||)
                                                                    (Pervasives.(&&)
                                                                    (Pervasives.(>=)
                                                                    (Pervasives.(-)
                                                                    (self__val_rml_118).time
                                                                    (self__val_rml_118).infectious_time)
                                                                    1)
                                                                    (self__val_rml_118).compliant)
                                                                    (Pervasives.(=)
                                                                    own_sector__val_rml_121
                                                                    C) then
                                                                    isolated
                                                                    self__val_rml_118
                                                                    else
                                                                    post_ebola
                                                                    self__val_rml_118
                                                                    interactions__val_rml_122
                                                                    sector_array__val_rml_115;
                                                                    self__val_rml_118.time
                                                                    <-
                                                                    Pervasives.(+)
                                                                    (self__val_rml_118).time
                                                                    1) )) ))
                                                                    ))) )
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
        | tmp__val_rml_124  -> Array.make_matrix maxx maxy tmp__val_rml_124 )

;;
let sector_array_create =
      (function
        | tmp__val_rml_126  ->
            Array.make_matrix sector_number sector_number tmp__val_rml_126
        ) 
;;
let get_status =
      (function
        | i__val_rml_128  ->
            (function
              | j__val_rml_129  ->
                  if Pervasives.(<) (Random.float 1.) 0.0002 then Infectious
                    else
                    if Pervasives.(<) (Random.float 1.) 0.0002 then Exposed
                      else Susceptible
              )
        ) 
;;
let cellular_automaton_start =
      (function
        | draw_cell__val_rml_131  ->
            (function
              | get_neighbors__val_rml_132  ->
                  (function
                    | get_status__val_rml_133  ->
                        (function
                          | cell_array__val_rml_134  ->
                              (function
                                | sector_array__val_rml_135  ->
                                    ((function
                                       | ()  ->
                                           Lco_ctrl_tree_record.rml_fordopar
                                             (function | ()  -> (0) )
                                             (function
                                               | ()  -> Pervasives.(-) maxx 1
                                               )
                                             true
                                             (function
                                               | i__val_rml_136  ->
                                                   Lco_ctrl_tree_record.rml_fordopar
                                                     (function | ()  -> (0) )
                                                     (function
                                                       | ()  ->
                                                           Pervasives.(-)
                                                             maxy 1
                                                       )
                                                     true
                                                     (function
                                                       | j__val_rml_137  ->
                                                           Lco_ctrl_tree_record.rml_if
                                                             (function
                                                               | ()  ->
                                                                   Pervasives.(&&)
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    j__val_rml_137
                                                                    sectormaxx)
                                                                    (0))
                                                                    (Pervasives.(=)
                                                                    (Pervasives.(mod)
                                                                    i__val_rml_136
                                                                    sectormaxy)
                                                                    (0))
                                                               )
                                                             (Lco_ctrl_tree_record.rml_par
                                                               (Lco_ctrl_tree_record.rml_run
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_131
                                                                    get_neighbors__val_rml_132
                                                                    i__val_rml_136
                                                                    j__val_rml_137
                                                                    (get_status__val_rml_133
                                                                    i__val_rml_136
                                                                    j__val_rml_137)
                                                                    cell_array__val_rml_134
                                                                    sector_array__val_rml_135
                                                                   ))
                                                               (Lco_ctrl_tree_record.rml_run
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    sector
                                                                    ((Pervasives.(/)
                                                                    i__val_rml_136
                                                                    sectormaxx),
                                                                    (Pervasives.(/)
                                                                    j__val_rml_137
                                                                    sectormaxy))
                                                                    sector_array__val_rml_135
                                                                   )))
                                                             (Lco_ctrl_tree_record.rml_run
                                                               (function
                                                                 | ()  ->
                                                                    cell
                                                                    draw_cell__val_rml_131
                                                                    get_neighbors__val_rml_132
                                                                    i__val_rml_136
                                                                    j__val_rml_137
                                                                    (get_status__val_rml_133
                                                                    i__val_rml_136
                                                                    j__val_rml_137)
                                                                    cell_array__val_rml_134
                                                                    sector_array__val_rml_135
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
                                 (Pervasives.( * ) maxx zoom))
                               (Pervasives.(^)
                                 "x"
                                 (Pervasives.string_of_int
                                   (Pervasives.( * ) maxy zoom)))));
                         Graphics.auto_synchronize false
                   ))
               (Lco_ctrl_tree_record.rml_signal
                 (function
                   | tmp_cell__sig_139  ->
                       Lco_ctrl_tree_record.rml_signal
                         (function
                           | tmp_sector_p__sig_140  ->
                               Lco_ctrl_tree_record.rml_signal
                                 (function
                                   | tmp_sector_a__sig_141  ->
                                       Lco_ctrl_tree_record.rml_def
                                         (function
                                           | ()  ->
                                               new_cell
                                                 5
                                                 5
                                                 tmp_cell__sig_139
                                                 Susceptible ((0), (0))
                                           )
                                         (function
                                           | dummy_cell__val_rml_142  ->
                                               Lco_ctrl_tree_record.rml_def
                                                 (function
                                                   | ()  ->
                                                       new_sector
                                                         C
                                                         tmp_sector_p__sig_140
                                                         tmp_sector_a__sig_141
                                                         ((0), (0))
                                                   )
                                                 (function
                                                   | dummy_sector__val_rml_143
                                                        ->
                                                       Lco_ctrl_tree_record.rml_def
                                                         (function
                                                           | ()  ->
                                                               cell_array_create
                                                                 dummy_cell__val_rml_142
                                                           )
                                                         (function
                                                           | cell_array__val_rml_144
                                                                ->
                                                               Lco_ctrl_tree_record.rml_def
                                                                 (function
                                                                   | 
                                                                   ()  ->
                                                                    sector_array_create
                                                                    dummy_sector__val_rml_143
                                                                   )
                                                                 (function
                                                                   | 
                                                                   sector_array__val_rml_145
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_def
                                                                    (function
                                                                    | ()  ->
                                                                    draw_cell_gen
                                                                    color_of_status
                                                                    )
                                                                    (function
                                                                    | draw__val_rml_146
                                                                     ->
                                                                    Lco_ctrl_tree_record.rml_par
                                                                    (Lco_ctrl_tree_record.rml_run
                                                                    (function
                                                                    | ()  ->
                                                                    cellular_automaton_start
                                                                    draw__val_rml_146
                                                                    get_von_neumann_neighbors
                                                                    get_status
                                                                    cell_array__val_rml_144
                                                                    sector_array__val_rml_145
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
