open Init;
open Pitch;
structure Display =
struct
(* position *)
val TopLeft =  0     (* + 3 for bottom line *)
val TopCenter =  1
val TopRight =  2
val BottomLeft = 8
val BottomCenter =  9
val BottomRight = 10
val TopLeft_ =  3     (* add _ for bottom + 3 for bottom line *)
val TopCenter_ =  4
val TopRight_ =  5
val BottomLeft_ = 11
val BottomCenter_ =  12
val BottomRight_ = 13

val Middle =  6	 (* + 1 = bottom line *)
val Middle_ =  7	
(* alignment *)		  
val Centered = 0
val LeftAligned = 1
val RightAligned = 2

		       
val folder_icon =   0x0A (* "\n" *)
val note_glyph =   0x0B
val power_icon =  0x1B 
val check_mark =  0x1C 
val X_mark =  0x1D 
val thin_circle =  0x1E
val thick_circle =  0x1F
val degree_symbol =  0x7F

type display = {name: string, position:int}
val displays = Array.array(12,{name="", color = [127,127,127], position= ~1})
val actif = ref TopLeft
						       			       (*
sendText "Sol/Do" TopLeft [110,127,0] Centered
sendText "GC" (TopLeft + 3) [110,127,0] 7)
sendText "" (Middle+1) [0,0,0] Centered
RGB is 7 bits     pos color---   e  l  l  o
F0 00 01 06 22 12 05 00 7F 00 00 65 6C 6C 6F F7
									       *)
		
datatype lcd_text = Int of int | String of string
					      
fun sendText (to_display:lcd_text, position :int, rgb:int list,  align:int) =
    let val header =  [0xF0, 0x00, 0x01, 0x06, 0x22, 0x12]
	val position2 = position :: []
	val color = rgb (*  [0x00,0x7F,0x00] *)
	val align2 =  align :: []
	val texte2 =  case to_display of Int symbol => symbol :: []
				  | String texte => map Char.ord (String.explode texte)
	val end_sysex =  [0xF7]
	val final1 = header @ position2 @ color @ align2 @ texte2 @ end_sysex
	val final = Array.fromList (map Word8.fromInt final1)
    in
	writeSysex  ATOMSQ_out (ptTime()) final
    end


(*
https://community.cantabilesoftware.com/t/presonus-atom-sq-review-midi-info/10225 :
The 34 lighted pad colors are controlled via note events for notes 36-51 (bottom row),
52-67 (top row) (hex 0x24-0x33 and 0x34-0x43),
and 0-1 (+/- buttons at left of top row).
 Note events on channel 1 control the light state
(velocity 0 = unlit, velocity 1 = blink, velocity 2 = breathe, and velocity 127 = lit).
Note events on channels 2-4 set the Red, Green, and Blue (respectively) hues equal to note velocity.
 *)

val unlit = 0
val blink = 1
val breathe = 2
val lit = 127

      
fun padColor (note,lit,r,g,b) =
    (
      writeShort ATOMSQ_out 0 (message (0x90,note,lit));
      writeShort ATOMSQ_out 0 (message (0x91,note,r));
      writeShort ATOMSQ_out 0 (message (0x92,note,g));
      writeShort ATOMSQ_out 0 (message (0x93,note,b));
      ()
    )
      

(* show notes ctrls key label on atomSQ top left
00 -> A
01 -> B
02 -> C
03 -> D
04 -> E
05 -> F
06 -> G
07 -> H

6F -> stop -> sharp
6D -> Play -> flat
 *)

	      
fun showNote ( ts, (note: pitch), velocity) =
    let val sharp =0x6B
	val flat = 0x6D
	val (note,_) = note
	val (ctrl_number, alteration) =
	    case note of
		   C => (2,0)
		|  Cs => (2,sharp)
		| Db => (3,flat)
		| D => (3,0)
		| Ds => (3,sharp)
		| Eb => (4,flat)      
		| E => (4,0)
		| F => (5,0)
		| Fs => (5,sharp)
		| Gb => (6,flat)
		| G => (6,0)
		| Gs => (6,sharp)
		| Ab => (0,flat)
		| A => (0,0)
		| As => (0,sharp)
		| Bb => (1,flat)
		| B => (1,0)
    in
	(writeShort ATOMSQ_out ts (message (0xB0,ctrl_number,velocity));
	if alteration > 0 then
	    writeShort ATOMSQ_out ts (message (0xB0,alteration,velocity))
	else 0
	)
    end

	
	
	
end
    
    

