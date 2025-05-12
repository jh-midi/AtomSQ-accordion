atomSQ: init.sml display.sml main.sml atomsq_ok.sml portmidi.sml portmidi_mlton_FFI_lib.sml atomSQ.mlb
	mlton -default-ann 'allowFFI true'  -link-opt '-Wl,-rpath=/usr/local/lib64 -lportmidi -lasound' atomSQ.mlb

atomStatic:  atomsq_ok.sml portmidi.sml portmidi_mlton_FFI_lib.sml atomSQ.mlb
	mlton  -default-ann 'allowFFI true'  -link-opt '-L/usr/local/lib64 -l:libportmidi.a -lasound' atomSQ.mlb
