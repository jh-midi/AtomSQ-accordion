open AtomSQ;
open Init;



fun main  tuning  =
    (
      fillKeyboard tuning;
      setProgrammable true; 
      ptSleep 100;
      setProgrammable true; 
      ptSleep 100;  (* I don't know why 2nd trying *)
      showActif tuning;
(* if args in cmd line then showDevices() else show nothing *)
      if List.null  (CommandLine.arguments())  then () else showDevices();
      showRelative();
      sendText (String ( #accord si_do), #position si_do, #color si_do, Centered);
      sendText (String ( #accord sol_do), #position sol_do, #color sol_do, Centered);
      List.app (fn x => padColor (x,127,0,64,0)) [0x37,0x3A,0x3D,0x40,0x43];
      padColor (0x25,127,60,60,0);
      padColor (0x24,127,50,0,37);
      sendText ( String ("knob step = " ^ Int.toString (!knob_step)),
		 Middle, [0,50,50], Centered); 
      sendText ( String ( "Bank " ^ Char.toString (chr (ord #"A" + !bank))),
		 BottomCenter,[100,0,80], Centered );
     
      let val buf= bufferNew 1
	  val _ = print "\n\n  ****   Play Atom SQ  ****\n"
	  val scan_latency' = Time.fromMicroseconds (Int.toLarge 80)
	  val err = setFilter(ATOMSQ_in,logior [filt_poly_aftertouch])
      in
	  while true do (
	      OS.Process.sleep scan_latency' ; (* near real time *)
	      if (read ATOMSQ_in buf 1) = 1
	      then discri (bufferElt  buf 0)
	      else  5
			
	  )
		
      end
    )
   

    

val _ =  main si_do 

	 
