; -----------------------------------
; 3D Taster Makro 
; Version: 1.0
; Ersteller: Markus Koch
; -----------------------------------
; Verwendete Parameter fuer 3D Taster
; -----------------------------------
; #4009 Suchgeschwindigkeit 
; #4010 Tastgeschwindigeit
; #4011 Rueckzuggeschwindigkeit X/Y 
; #4012 Rueckzuggeschwindigkeit Z
; #4013 Rueckzug Z (mm) 
; #4014 Rueckzug X/Y (mm) 
; #4015 max. Suchweg X/Y (mm) 
; #4016 max. Tastweg X/Y (mm) 
; #4017 Tastkopf Durchmesser (mm) 
; -----------------------------------

; ---------------------------------------------------------
; Antasten einer Achse (Kante = Nullpunkt)
; ---------------------------------------------------------

sub x_plus	; X Achse in Richtung X+ antasten
	G91				; wechsel auf relative Koordinaten
	G38.2 X#4015 F#4009	; Fahre zum Werkstueck in Richtung X+ mit Suchgeschwindigkeit bis Taster ausloest oder maximaler Suchweg abgefahren ist. 
		
	if [#5067 == 1]	; Wenn sich das Tastersignal geaendert hat dann ->
		G38.2 X-[#4016] F#4010	; Fahre vom Werkstueck in Richtung X-  mit Tastgeschwindigkeit weg bis Taster erneut ausloest oder maximaler Tastweg abgefahren ist.
		G90	; wechsel auf absolute Koordinaten
		if [#5067 == 1]	; Wenn sich das Tastersignal geaendert hat dann ->
			G4 P1		; Warte 1 Sekunde damit die Achse in absoluter Ruheposition ist
			G92 X0		; Setze Werkstuecknullpunkt X=0
			G91		; wechsle auf relative Koordinaten
			G1 X-[#4014] F#4011	; Fahre vom Tastpunkt weg in Richtung X- um Rueckzug X/Y mit Rueckzugsgeschwindigkeit X/Y
			G1 Z#4013 F#4012		; Fahre Z Achse um Rueckzug Z in Richtung Z+ mit Rueckzugsgeschwindigkeit Z hoch
			G90				; wechsel auf absolute Koordinaten
			msg "Werkstuecknullpunkt X+ wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif
endsub

sub y_minus	 	; Y Achse in Richtung Y- antasten
	G91
	G38.2 Y-[#4015] F#4009
	
	if [#5067 == 1]
		G38.2 Y#4016 F#4010
		G90
		if [#5067 == 1]
			G92 Y0
			G91
			G1 Y#4014 F#4011
			G1 Z#4013 F#4012
			G90
			msg "Werkstuecknullpunkt Y+ wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif
endsub

sub x_minus	 	; X Achse in Richtung X- antasten
	G91
	G38.2 X-[#4015] F#4009
	
	if [#5067 == 1]
		G38.2 X#4016 F#4010
		G90
		if [#5067 == 1]
			G92 X0
			G91
			G1 X#4014 F#4011
			G1 Z#4013 F#4012
			G90
			msg "Werkstuecknullpunkt X- wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif
endsub

sub y_plus	 	; Y Achse in Richtung Y+ antasten
	G91
	G38.2 Y#4015 F#4009
	
	if [#5067 == 1]
		G38.2 Y-[#4016] F#4010
		G90
		if [#5067 == 1]
			G92 Y0
			G91
			G1 Y-[#4014] F#4011
			G1 Z#4013 F#4012
			G90
			msg "Werkstuecknullpunkt Y+ wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif
endsub

sub user_11
	gosub x_plus
endsub

sub user_12
	gosub y_minus
endsub

sub user_13
	gosub x_minus
endsub

sub user_14
	gosub y_plus
endsub

; ---------------------------------------------------------
; Antasten von zwei Achsen (Ecke = Nullpunkt)
; ---------------------------------------------------------
sub user_15 	; X_minus / Y_minus (Rechts_Oben)
	msg "	Fahren Sie auf X Position >> weiter mit STRG+G"
	M0
	gosub x_plus
	msg "	Fahren Sie auf Y Position >> weiter mit STRG+G"
	M0				
	gosub y_minus
	G90
	G53 G0 Z0
	G54 G0 X0 Y0
	msg "Antasten abgeschlossen"
endsub

; ------------------------------------------------------------------------------------
; Beispiel zur automatischen Positionierung auf Y Position nach vermessen der X Achse
; ------------------------------------------------------------------------------------
sub auto_1 	; X_plus / Y_minus (Links_Oben)
	msg "	Fahren 	Sie auf X Position >> weiter mit STRG+G"		; Manuell auf Startposition fuer X Achse verfahren
	M0								; Warte auf Tastatureingabe STRG+G "Start Button" oder auf Handrad "Gruene Taste"
	G91				; wechsel auf relative Koordinaten
	G38.2 X#4015 F#4009	; Fahre zum Werkstueck in Richtung X+ mit Suchgeschwindigkeit bis Taster ausloest oder maximaler Suchweg abgefahren ist. 
		
	if [#5067 == 1]	; Wenn sich das Tastersignal geaendert hat dann ->
		G38.2 X-[#4016] F#4010	; Fahre vom Werkstueck in Richtung X-  mit Tastgeschwindigkeit weg bis Taster erneut ausloest oder maximaler Tastweg abgefahren ist.
		G90	; wechsel auf absolute Koordinaten
		if [#5067 == 1]	; Wenn sich das Tastersignal geaendert hat dann ->
			G4 P1		; Warte 1 Sekunde damit die Achse in absoluter Ruheposition ist
			G92 X0		; Setze Werkstuecknullpunkt X=0
			G91		; wechsle auf relative Koordinaten
			G1 X-[#4014] F#4011	; Fahre vom Tastpunkt weg in Richtung X- um Rueckzug X/Y mit Rueckzugsgeschwindigkeit X/Y
			msg "Werkstuecknullpunkt X+ wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif	
								
	G0 Y+20
	G0 X+20

	G38.2 Y-[#4015] F#4009
	if [#5067 == 1]
		G38.2 Y#4016 F#4010
		G90
		if [#5067 == 1]
			G92 Y0
			G91
			G1 Y#4014 F#4011
			G90
			msg "Werkstuecknullpunkt Y+ wurde gesetzt"
		endif
	else
	warnmsg "!!! Maximaler Suchweg wurde erreicht - Taster nicht gefunden !!!"
	endif
	G90								; wechsel auf absolute Koordinaten
	G53 G0 Z0							; Fahre Z Achse auf Sicherheitshoehe
	G54 G0 X0 Y0							; Fahre auf 
	msg "Antasten abgeschlossen"
endsub
; ------------------------------------------------------------------------------------
; Beispiel ENDE
; ------------------------------------------------------------------------------------

sub user_16 	; X_minus / Y_minus (Rechts_Oben)
	msg "	Fahren Sie auf X Position >> weiter mit STRG+G"
	M0
	gosub x_minus
	msg "	Fahren Sie auf Y Position >> weiter mit STRG+G"
	M0				
	gosub y_minus
	G90
	G53 G0 Z0
	G54 G0 X0 Y0
	msg "Antasten abgeschlossen"
endsub

sub user_17 	; X_minus / Y_plus (Rechts_Unten)
	msg "	Fahren Sie auf X Position >> weiter mit STRG+G"
	M0
	gosub x_minus
	msg "	Fahren Sie auf Y Position >> weiter mit STRG+G"
	M0				
	gosub y_plus
	G90
	G53 G0 Z0
	G54 G0 X0 Y0
	msg "Antasten abgeschlossen"
endsub

sub user_18 	; X_plus / Y_plus (Links_Unten)
	msg "	Fahren Sie auf X Position >> weiter mit 	STRG+G"
	M0
	gosub x_plus
	msg "	Fahren Sie auf Y Position >> weiter mit 	STRG+G"
	M0				
	gosub y_plus
	G90
	G53 G0 Z0
	G54 G0 X0 Y0
	msg "Antasten abgeschlossen"
endsub

sub user_20
	dlgmsg "taster" "	Suchgeschw. (mm	/min)"4009 "Tastgeschw. (mm/min)"4010 "Rueckzuggeschw. X/Y (mm/min)"4011 "Rueckzuggeschw. Z (mm/min)"4012 "Rueckzug Z (mm)"4013 "Rueckzug X/Y (mm)"4014 "Suchweg max. X/Y (mm)"4015 "Tastweg max. X/Y (mm)"4016 "Tastkopf Durchm. (mm)"4017
endsub