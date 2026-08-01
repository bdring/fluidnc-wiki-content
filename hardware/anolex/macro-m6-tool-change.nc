; ========== macro-M6-tool-change.nc
; Probe work Z-zero position for first tool, probe toolsetter (tset) for all tools,
;   and set WCS to work zero after each tool change, adjusting Z for bit length.
;
;        - needs G28 defined as home position (toolsetter is centered below this)
;        - needs G30 defined as park/tool-change position above work (work zero is below this)
;        - probe plate located on spoilboard (or top of work) below park position
;        - toolsetter used to find toolbit tip mpos height
;        - active WCS (typ G54) has work zero adjusted after tool-change probing

; ===== params:
#<probe_plate_thickness_mm> = 15.05

#<probe_fast_mm_per_min> = 150
#<probe_slow_mm_per_min> = 30
#<probe_safe_z_mpos_mm> = -1.0        ; way up
#<probe_retract_height_mm> = 3.0      ; just a tad

;;;; rapid to MAX-HEIGHT-WORK start pos (using longest 2.5" tool) -- about 100mm to spoilboard
;;;#<probe_start_z_mpos_mm> = -20
; rapid to NORMAL-HEIGHT-WORK start pos (using longest 2.5" tool) -- about 40mm to spoilboard
#<probe_start_z_mpos_mm> = -80

#<probe_lowest_z_mpos_mm> = -130      ; never probe lower than this over work

#<tset_start_z_mpos_mm> = -50         ; rapid to tset start pos (longest 2.5" tool ok)
#<tset_lowest_z_mpos_mm> = -100       ; this is collet about 12mm over toolsetter

(print, )
(print, ===== macro M6 running to load Tool: #5400)
(print, )

; ===== check for valid tool number:
o100 if [#<_selected_tool> GT 0]

  ; turn spindle off (just in case):
  M5
  ; set _current_tool:
  M61Q#<_selected_tool>


  ; ==================== move to TOOL-CHANGE/PARK position (G30) over WORK:
  (print, Move to Tool-Change/Park G30 position...)
  G53 G0 Z#<probe_safe_z_mpos_mm>       ; just in case, retract way up to clear anything
  G4 P0.1                               ; wait for motion to complete
  G30                                   ; go to park position
  G4 P0.1                               ; wait for motion to complete
  ; ----- pause:
  (print, )
  (print, >>>>> PAUSED TO CHANGE TO TOOL: #5400 -- Cycle-Start or '~' to continue)
  o150 if [#<_selected_tool> EQ 1]
    (print,       >>> Also position probe plate and clip lead as needed)
  o150 endif
  M0  ; pause


  ; ===== FIRST TOOL T1 ONLY: after user continues, probe for G30 Work Z-zero:
  o200 if [#<_selected_tool> EQ 1]
    (print, )
    (print, First tool T1: Probe G30 Work Z Zero...)

    ; rapid to start height:
    G53 G0 Z#<probe_start_z_mpos_mm>
    ; first a fast probe speed:
    G38.2 G53 Z#<probe_lowest_z_mpos_mm> F#<probe_fast_mm_per_min>
    ; retract a little bit from current z mpos (_abs_z is current Z in mpos):
    G53 G1 Z[#<_abs_z> + #<probe_retract_height_mm>] F#<probe_fast_mm_per_min>
    ; then a slow probe speed (P0 is no offset, to get height of probe tip in mpos coord):
    G38.2 G53 Z#<probe_lowest_z_mpos_mm> F#<probe_slow_mm_per_min> P0

    ; --- save work Z-zero at bottom-of-probe-plate (#5063 is G38 probe result for Z in mpos):
    #<work_z_mpos_mm> = [#5063 - #<probe_plate_thickness_mm>]
    (print, )
    (print, First tool T1: WORK ZERO Z is #<work_z_mpos_mm> mm)
    (print, )


  ; ===== NEXT TOOLS, after user continues -- these are previous positions, fyi:
  o200 else
    ; previously-probed work Z-zero:
    (print, NEXT TOOL: previous Work Zero Z is #<_GLOBAL_work_prev_z_mpos_mm> mm)
    ; previous toolsetter height:
    (print, NEXT TOOL: previous ToolSetter Z is #<_GLOBAL_tset_prev_z_mpos_mm> mm)
    (print, )
  o200 endif


  ; ==================== now move to TOOLSETTER position over HOME (G28) and probe to find bit height:
  (print, Move to ToolSetter/Home G28 position...)
  G53 G0 Z#<probe_safe_z_mpos_mm>       ; just in case, retract way up to clear anything
  G4 P0.1                               ; wait for motion to complete
  G28                                   ; go to home position
  G4 P0.1                               ; wait for motion to complete
  (print, )
  (print, Probe G28 ToolSetter...)

  ; rapid to start height:
  G53 G0 Z#<tset_start_z_mpos_mm>
  ; first a fast probe speed:
  G38.2 G53 Z#<tset_lowest_z_mpos_mm> F#<probe_fast_mm_per_min>
  ; retract a little bit from current z mpos (_abs_z is current Z in mpos):
  G53 G1 Z[#<_abs_z> + #<probe_retract_height_mm>] F#<probe_fast_mm_per_min>
  ; then a slow probe speed (P0 is no offset, to get height of probe tip in mpos coord):
  G38.2 G53 Z#<tset_lowest_z_mpos_mm> F#<probe_slow_mm_per_min> P0

  ; --- save toolbit tip height:
  #<tset_z_mpos_mm> = #5063           ; #5063 is G38 probe result for Z in mpos
  (print, )
  (print, TOOLSETTER Z is #<tset_z_mpos_mm> mm)
  (print, )


  ; ==================== return to TOOL-CHANGE/PARK position (G30) over WORK:
  (print, Move to Tool-Change/Park G30 position...)
  G53 G0 Z#<probe_safe_z_mpos_mm>       ; just in case, retract way up to clear anything
  G4 P0.1                               ; wait for motion to complete
  G30                                   ; go to park position
  G4 P0.1                               ; wait for motion to complete


  ; ===== FIRST TOOL T1 ONLY, save the work Z-zero we just probed (and G30 X/Y) to active WCS:
  o300 if [#<_selected_tool> EQ 1]

    ; --- save tset for next-tool use:
    #<_GLOBAL_tset_prev_z_mpos_mm> = #<tset_z_mpos_mm>

    ; --- save work z for next-tool use:
    #<_GLOBAL_work_prev_z_mpos_mm> = #<work_z_mpos_mm>

    ; --- save G30 X (#5181) and Y (#5182) and work Z height to active WCS P0 (typ G54):
    G10 L2 P0 X#5181 Y#5182 Z#<work_z_mpos_mm>


  ; ===== NEXT TOOLS, adjust work Z-zero by new bit height:
  o300 else

    #<z_adjustment> = [#<tset_z_mpos_mm> - #<_GLOBAL_tset_prev_z_mpos_mm>]

    #<work_adjusted_z_mpos_mm> = [#<_GLOBAL_work_prev_z_mpos_mm> + #<z_adjustment>]

    (print, )
    (print, NEXT TOOL: z_adjustment is #<z_adjustment> mm)
    (print, NEXT TOOL: adjusted work zero Z is #<work_adjusted_z_mpos_mm> mm)
    (print, )

    ; --- save tset for next-tool use:
    #<_GLOBAL_tset_prev_z_mpos_mm> = #<tset_z_mpos_mm>

    ; --- save adjusted work z for next-tool use:
    #<_GLOBAL_work_prev_z_mpos_mm> = #<work_adjusted_z_mpos_mm>
    
    ; --- save G30 X (#5181) and Y (#5182) and adjusted work Z height to active WCS P0 (typ G54):
     G10 L2 P0 X#5181 Y#5182 Z#<work_adjusted_z_mpos_mm>

  o300 endif

  (print, )
  (print, ===== macro M6 completed -- Changed to Tool: #<_selected_tool>)


  ; ==================== pause:
  (print, )
  (print, >>>>> PAUSED -- READY TO START CUTTING?  -- Cycle-Start or '~' to continue)
  o150 if [#<_selected_tool> EQ 1]
    (print,       >>> Remove position probe plate and clip lead)
  o150 endif
  (print, )
  M0  ; pause

  (print, >>>>> CUTTING WITH TOOL: #5400)

o100 else
  (print, ===== Macro M6 aborted -- Tool: #<_selected_tool>, is invalid)
  ; eg: T0 was selected:
  M61Q0   ; reset _current_tool to invalid
  ; reset anything else here?

o100 endif
