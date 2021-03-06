C         THIS IS EDIT10, A BASIC INTERACTIVE GRAPHIC EDITOR.
      DIMENSION ILEAD(10),FLEAD(10)
      COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1,IROUTE
      COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
      COMMON /GRP3/ XOFFP,YOFFP,XMAGP,YMAGP
      COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
      REAL I(3000)
      DIMENSION IX(27)
      DATA IX/46,47,65,67,68,71,73,76,83,69,81
     1,84,77,82,80,85,42,88,89,70,33,32,79,78,74,87,86/
      CALL INITT(120)
      CALL BELL
      TYPE 9
9     FORMAT(1H+,'ENTER BAUD RATE (CHAR/SEC) FOR THIS RUN.',/)
      ACCEPT 13,IBAUD
13    FORMAT(G)
      CALL INITT(IBAUD)
      MINU=0
      WIDTH=800.
      HEIGHT=700.
      TOP=605.
      NUMELS=3000
C         DEFINES MAX. SCREEN AREA FOR 'FRAME','SCALE-X',AND 'SCALE-Y'.
      MRG=1
      HUG=-1
      N=0
      CALL UNIT
      CALL INIT
      GO TO 800
50    CONTINUE
C         GO LIST AND PLOT THE FILE STATUS.
C         BELOW IS THE RE-ENTRY POINT FOR NEARLY ALL ROUTINES.
  10  CALL GRAFIN
      ICHAR=IROUTE
      DO 11 IJ=1,27
         IK=IJ
         IF(IROUTE.EQ.IX(IK))GO TO 12
11    CONTINUE
      TYPE 60
60    FORMAT(1H+,'ILLEGAL RESPONSE')
      GO TO 10
12    IROUTE=IK
      GO TO(100,200,300,400,500,600,700,800,900,
     11000,1100,1200,1400,1500,1600,1700,1800,1900,2000,
     22100,2200,2300,2500,2600,2700,2800,2900),IROUTE
C         THE FOLLOWING TABLE SHOWS THE ACTION OF THE ABOVE GOTO'S.
C         IF /CHAR. GOTO/  /CHAR. GOTO/  /CHAR. GOTO/  /CHAR. GOTO/
C            / "."   100/  / "/"   200/  / "A"   300/  / "C"   400/
C            / "D"   500/  / "G"   600/  / "I"   700/  / "L"   800/
C            / "S"   900/  / "E"  1000/  / "Q"  1100/  / "T"  1200/
C            / "M"  1400/  / "R"  1500/  / "P"  1600/  / "U"  1700/
C            / "*"  1800/  / "X"  1900/  / "Y"  2000/  / "F"  2100/
C            / "!"  2200/  / " "  2300/  / "O"  2500/  / "N"  2600/
C            / "J"  2700/

C         THIS IS WHERE POINTS ARE DRAWN.
100   N=N+1
      J=N
 110  IF (J-1-NUMELS)115,190,190
 115  CALL SETEM
      CALL TOUTPT(25)
120   XP=XOP+(X(J)+XOFFP)*XMAGP
      YP=YOP+(Y(J)+YOFFP)*YMAGP
      IF(ICHAR-46)10,121,122
121   CALL POINTA(XP,YP)
      GO TO 123
122   CALL DRAWA(XP,YP)
123   CALL ANMODE
      IF (HUG)10,310,310
C         THE ABOVE PLOTS THE POINT X(J),Y(J) OR THE BRIGHT VECTOR
C         TO THIS POINT FROM X(J-1),Y(J-1) IF 200 HAS BEEN EXECUTED.

C         THIS IS THE ILLEGAL ELEMENT RECOVERY POINT.
 190  CALL WHAT
      N=NUMELS
      GO TO 10

C         THIS IS WHERE BRIGHT VECTORS ARE DRAWN.
200   N=N+1
      J=N
 210  IF (J-1-NUMELS)230,190,190
230   IF(J.GT.1)GO TO 240
      ICHAR=46
      GO TO 115
240   CALL SETEM
      XP=XOP+(X(J-1)+XOFFP)*XMAGP
      YP=YOP+(Y(J-1)+YOFFP)*YMAGP
      CALL MOVEA(XP,YP)
      GO TO 120
C         DRAW DARK VECTOR TO THE PREVIOUS POINT.

 300  YTMP=RGY
      HUG=HUG+1
 310  CALL LINE
      CALL ALFIN
      ICHAR=IG+46
 320  IF (IG-1)100,200,330
 330  IF (IG-11)200,340,200
 340  HUG=-1
      GO TO 10
C         TAKE IN I(J),X(J),Y(J) ALPHANUMERICALLY.

 400  IF (N)410,410,420
 410  CALL WHAT
      GO TO 1210
420   CALL LOCATE
C         GET ELEM NO. NEAREST CURSOR
 430  CALL GRAFIN
      HUG=-1
      IF (ICHAR-65)450,440,450
 440  YTMP=RGY
      CALL ALFIN
 450  IF (IG-1)110,210,210
C         CHANGE SPECIFIED ELEMENT TO NEW VALUE.

 500  TYPE 510
 510  FORMAT(1H+,12HDELETE LAST ,$)
      ACCEPT 520,KNUM
 520  FORMAT(G)
      N=N-KNUM
      IF (N)530,800,800
 530  N=0
      GO TO 800
C         FIND OUT HOW MANY TO DELETE AND LIST/PLOT FILE STATUS.

 600  IF (N)10,10,605
 605  CALL DEFINE
 610  IF (J)620,620,640
 620  CALL WHAT
      ACCEPT 520,J
      GO TO 610
 640  IF (J-N)645,645,620
 645  CALL ERASE
      DO 650 K=1,J
         XP=XOP+(X(K)+XOFFP)*XMAGP
         YP=YOP+(Y(K)+YOFFP)*YMAGP
         IF(I(K).EQ.0.)CALL MOVEA(XP,YP)
650   CALL DRAWA(XP,YP)
      CALL ANMODE
      CALL ANCHO(88)
660   TYPE 670,J,I(J),X(J),Y(J)
 670  FORMAT(1H+,/,11H ELEM. NO. ,I4,F2.0,2F12.4)
      GO TO 10
C         PLOT ELEMENTS 1 THRU 'J' AND IDENTIFY ELEM(J).

 700  CALL LOCATE
      CALL GRAFIN
      TYPE 710,J,I(J),X(J),Y(J)
 710  FORMAT(1H+,10HELEM. NO. ,I4,2X,F2.0,2F12.4)
      GO TO 10
C         PRINT INFO ON ELEM. NEAREST CURSOR.

800   CALL NEWPAG
      KNUM=NUMELS-N
      TYPE 810,N,KNUM
 810  FORMAT(1H+,9HUSED     ,I5,/,10H AVAILABLE ,I5)
      IF (MINU)830,830,820
 820  YTMP=200.
      CALL MENON
 830  IF (N-1)10,10,840
840   DO 850 J=1,N
         XP=XOP+(X(J)+XOFFP)*XMAGP
         YP=YOP+(Y(J)+YOFFP)*YMAGP
         IF(I(J).GT.0.)GO TO 845
         CALL MOVEA(XP,YP)
         GO TO 850
845      CALL DRAWA(XP,YP)
850   CONTINUE
      CALL ANMODE
      GO TO 10
C         DISPLAY FILE STATUS

 900  CALL DEFINE
      GO TO 430
C         GET ELEM. NO. TO BE MODIFIED.

1000  TYPE 1010
1010  FORMAT(1H+,12HLAST ELEM.= ,$)
1020  ACCEPT 520,N
      IF (N)1040,1050,1050
1040  CALL WHAT
      GO TO 1020
1050  IF (N-NUMELS)800,800,1040
C         GET LAST ELEM. NO. TO SPECIFY FILE SIZE

1100  CALL ERASE
      GO TO 5000
C         RESET MONITOR SWITCHES AND EXIT TO SYSTEM MONITOR.

1200  CALL NEWPAG
      IF (N)1210,1210,1230
1210  TYPE 1220
1220  FORMAT(12H VIRGIN FILE)
      N=0
      GO TO 10
1230  TYPE 1232
1232  FORMAT(' ENTER 1ST (COMMA) LAST ELEM TO BE TYPED',/)
      ACCEPT 1235,J1,J2
1235  FORMAT(2G)
      CALL NEWPAG
      DO 1240 J=J1,J2
1240  TYPE 1250,J,I(J),X(J),Y(J)
1250  FORMAT(I5,F2.0,2F12.4)
      GO TO 10
C         TYPE THE SPECIFICATIONS OF ALL ELEMENTS.
C         WE ARE ABOUT TO GO THRU A MAGNIFICATION ROUTINE.
1400  YTMP=RGY
      CALL DATA
C         SEE HOW MUCH DATA IS TO BE CHANGED.
      CALL MAGGIN
C         GET PARAMETERS.
      CALL PIKREF
1420  XOFF=-GX
      YOFF=-GY
1430  K=N-L2
      DO 1440 J=MRG,K
1440  CALL SCALEM
      GO TO 800
C         CHANGE DATA AND PLOT IT.

C         THE FOLLOWING DOES A ROTATION OF AXES.
1500  YTMP=RGY
      CALL DATA
C         SEE HOW MUCH DATA IS TO BE SCALED.
      CALL ROTOR
C         GET PARAMETERS.
      CALL PIKREF
      GO TO 1420
C         PICK A REFERENCE POINT AND GO LIST NEW STAUTS.

C         GET SET FOR TRANSLATION OF AXES.
1600  X1=GX
      Y1=GY
      CALL TOUTPT(25)
      CALL POINTA(RGX,RGY)
      CALL ANMODE
      CALL INIT
1610  CALL GRAFIN
      YTMP=RGY
      IF (ICHAR-65)1610,1660,1620
1620  IF (ICHAR-68)1610,1650,1630
1630  IF (ICHAR-80)1610,1640,1610
1640  XOP=XOP+GX-X1
      YOP=YOP+GY-Y1
      GO TO 800
C         HE DECIDED TO CHANGE PLOT PARAMETERS.
1650  XO=GX-X1
      YO=GY-Y1
      GO TO 1430
C         HE DECIDED TO SHIFT DATA FROM CURSOR POS'N 1 TO 2.
1660  TYPE 1665
1665  FORMAT(1H+,23HCHANGE DATA? (Y OR N): ,$)
1670  CALL TINPUT(IDAT)
      IF (IDAT-78)1675,1685,1680
1675  CALL ILLEGL
      GO TO 1670
1680  IF (IDAT-89)1675,1690,1675
1685  CALL LINE
      CALL SHIFT
      XOP=XOP+XO
      YOP=YOP+YO
      GO TO 800
1690  CALL LINE
      CALL DATA
      CALL SHIFT
      GO TO 1430
C         ACCEPT SHIFT INFO. ALPHANUMERICALLY.

C         SET PLOT PARAMETERS TO UNITY SCALING.
1700  CALL UNIT
      GO TO 800
C         AND LIST ALL ELEMENTS.

1800  YTMP=RGY
      CALL DATA
      CALL ROTOR
      CALL MAGGIN
      CALL SHIFT
      CALL LINE
      CALL PIKREF
      GO TO 1420
C         ROTATE, MAGNIFY, AND APPLY FINAL OFFSET ALL AT ONCE.

C         WE WILL NOW PERFORM AN AUTO-SCALE ON X.
1900  CALL MOVEA(RGX,0.)
      CALL DRAWA(RGX,780.)
      CALL ANMODE
      X1=GX
      CALL GRAFIN
      XOP=1000.-WIDTH
      IF(GX-X1)1930,1910,1910
1910  XOFFP=-X1
1920  XMAGP=WIDTH/(GX+XOFFP)
      GO TO 800
1930  XOFFP=-GX
      GX=X1
      GO TO 1920
2000  CALL MOVEA(0.,RGY)
      CALL DRAWA(1023.,RGY)
      CALL ANMODE
      Y1=GY
      CALL GRAFIN
      YOP=750.-HEIGHT
2010  IF(GY-Y1)2040,2020,2020
2020  YOFFP=-Y1
2030  YMAGP=HEIGHT/(GY+YOFFP)
      GO TO 800
2040  YOFFP=-GY
      GY=Y1
      GO TO 2030
2100  CALL MOVEA(RGX,0.)
      CALL DRAWA(RGX,760.)
      CALL MOVEA(0.,RGY)
      CALL DRAWA(1023.,RGY)
      CALL ANMODE
      X1=GX
      Y1=GY
      CALL GRAFIN
      XOP=1000.-WIDTH
      YOP=780.-HEIGHT
      IF(GX-X1)2130,2110,2110
2110  XOFFP=-X1
2120  XMAGP=WIDTH/(GX+XOFFP)
      GO TO 2010
2130  XOFFP=-GX
      GX=X1
      GO TO 2120
2200  MINU=IABS(MINU-1)
      GO TO 800
2300  YTMP=100.
      RGX=0.
      IF(MINU)50,50,2310
2310  NLINE=(645-IFIX(RGY))/22
      IF(NLINE-1)50,2320,2330
2320  CALL GRAFIN
      YTMP=RGY
      GO TO 2500
2330  NLINE=NLINE-1
      IF(NLINE-14)2340,1100,50
2340  IF(NLINE-12)2350,800,500
2350  IF(NLINE-11)2360,1200,50
2360  CALL GRAFIN
      YTMP=RGY
      GO TO (2600,2700,1400,1500,1690,1800,1900,2000,2100,1685),NLINE
C         READ A FILE FROM THE DISK
2500  MRG=1
      N=0
2505  L2=0
      YTMP=RGY
      CALL UNIT
      CALL INIT
      CALL GETNAM
      CALL IFILE (1,NAME)
      NN=N
      READ (1) ILEAD,FLEAD
      IF (ILEAD(1)+N-NUMELS)2520,2520,2510
2510  N=NUMELS
      GO TO 2530
2520  N=ILEAD(1)+N
2530  IF(N.GT.3000)N=3000
      READ(1) (I(J),X(J),Y(J),J=1+NN,N)
      UNLOAD 1
      GO TO 800

C         WRITE A FILE TO THE DISK.
2600  YTMP=RGY
      IF (N)1200,1200,2610
2610  ILEAD(1)=N
      ILEAD(2)=3
      ILEAD(3)=1
      CALL GETNAM
      CALL OFILE (1,NAME)
      WRITE (1) ILEAD,FLEAD
      WRITE(1) (I(J),X(J),Y(J),J=1,N)
      END FILE 1
      CALL LINE
      TYPE 2620
2620  FORMAT(1H+,5HDONE!)
      CALL BELL
      GO TO 10

C         JOIN A FILE TO WHAT'S ALREADY IN THE PROGRAM.
2700  MRG=N+1
      GO TO 2505

2800  CALL BELL
      CALL DCURSR(IC,IXMIN,IYMIN)
      IF(IC.EQ.48)GO TO 2810
      CALL DCURSR(IC,IX,IY)
      CALL SWINDO(IXMIN,IX-IXMIN,IYMIN,IY-IYMIN)
      IF(IC.NE.66)GO TO 2805
      CALL MOVABS(IXMIN,IYMIN)
      CALL DRWABS(IXMIN,IY)
      CALL DRWABS(IX,IY)
      CALL DRWABS(IX,IYMIN)
      CALL DRWABS(IXMIN,IYMIN)
2805  GO TO 10
2810  CALL SWINDO(0,1023,0,780)
      GO TO 10
2900  CALL BELL
      CALL VCURSR(IC,X1,Y1)
      IF(IC.EQ.48)GO TO 2910
      IF(IC.NE.66)GO TO 2905
      CALL MOVEA(RGX,RGY)
      CALL DRAWA(RGX,Y1)
      CALL DRAWA(X1,Y1)
      CALL DRAWA(X1,RGY)
      CALL DRAWA(RGX,RGY)
2905  CALL VWINDO(RGX,X1-RGX,RGY,Y1-RGY)
      GO TO 10
2910  CALL VWINDO(0.,1023.,0.,780.)
      GO TO 10
5000  END

      SUBROUTINE SETEM
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         X(J)=GX
         REAL I(3000)
         Y(J)=GY
         I(J)=FLOAT(IG)
         I(1)=0.
         RETURN
      END
C         DEFINE ELEM.(J) WITH CURRENT VALUES OF CURSOR POSITION.

      SUBROUTINE GRAFIN
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         COMMON /GRP3/ XOFFP,YOFFP,XMAGP,YMAGP
         REAL I(3000)
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         CALL VCURSR(IROUTE,RGX,RGY)
         ICHAR=IROUTE
         CALL MOVEA(RGX,RGY)
         CALL ANMODE
         IF(IROUTE.EQ.46)IG=0
         IF(IROUTE.EQ.47)IG=1
         GX=(RGX-XOP)/XMAGP-XOFFP
         GY=(RGY-YOP)/YMAGP-YOFFP
         RETURN
      END
C         GET CO-ORDINATES (FLOATING POINT) FROM CURSOR

      SUBROUTINE DEFINE
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         TYPE 10
         REAL I(3000)
 10      FORMAT(12H ELEM. NO.= ,$)
 20      ACCEPT 30,J
 30      FORMAT(G)
         IF (J)40,40,50
 40      CALL WHAT
         GO TO 20
 50      RETURN
      END
C         ACCEPT AN ELEMENT NUMBER. CALL IT 'J'

      SUBROUTINE WHAT
         TYPE 10
 10      FORMAT(/,1H+,18H ILLEGAL ELEM. NO.,/)
         RETURN
      END

      SUBROUTINE ALFIN
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         TYPE 10
         REAL I(3000)
 10      FORMAT(1H+,7HI,X,Y= ,$)
 20      ACCEPT 30,IG,GX,GY
 30      FORMAT(3G)
         IF (IG)50,60,60
 50      CALL ILLEGL
         GO TO 20
 60      RETURN
      END
C         ACCEPT I,X,Y ALPHANUMERICALLY.

      SUBROUTINE LOCATE
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         COMMON /GRP3/ XOFFP,YOFFP,XMAGP,YMAGP
         REAL I(3000)
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         IF (N-1)10,10,20
 10      J=1
         GO TO 50
 20      DMIN=1.6E38
         DO 40 K=1,N
            XP=GX-X(K)
            YP=GY-Y(K)
            DIST=XP*XP+YP*YP
            IF (DIST-DMIN)30,30,40
 30         DMIN=DIST
            J=K
 40      CONTINUE
50       XP=XOP+(X(J)+XOFFP)*XMAGP
         YP=YOP+(Y(J)+YOFFP)*YMAGP
         CALL MOVEA(XP,YP)
         CALL ANCHO(88)
         CALL ANMODE
         RETURN
C         FINDS NO. OF ELEM. NEAREST CURSOR. CALLS IT 'J'.
      END

      SUBROUTINE LINE
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         REAL I(3000)
         YTMP=YTMP-18.
         CALL MOVER(0.,-18.)
         CALL ANMODE
         RETURN
      END
C         GOES TO BEGINNING OF CURRENT LINE AND EFFECTS A LINEFEED.

      SUBROUTINE SHIFT
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         TYPE 10
10       FORMAT(1H+,26HENTER X OFFSET, Y OFFSET: ,$)
         ACCEPT 20,XO,YO
20       FORMAT(2G)
         RETURN
      END
C         ACCEPTS X AND Y OFFSETS ALPHANUMERICALLY

C         DETERMINE HOW MUCH, IF ANY, DATA IS DO BE SCALED.
      SUBROUTINE DATA
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
         REAL I(3000)
         CALL INIT
         TYPE 80
  80     FORMAT(1H+,30HENTER FROM ELEM.#, TO ELEM.#: ,$)
  90     ACCEPT 100,LIM1,LIM2
 100     FORMAT(2G)
         IF (LIM1)110,130,120
 110     CALL ILLEGL
         GO TO 90
 120     MRG=LIM1
 130     IF (LIM2)110,150,140
 140     L2=N-LIM2
 150     CALL LINE
         RETURN
      END
C         DEFINE LIMITS FOR ANY DATA MANIPULATION.

      SUBROUTINE ILLEGL
         CALL LINE
         TYPE 10
  10     FORMAT(1H+,18HILLEGAL RESPONSE :,$)
         RETURN
      END

      SUBROUTINE PIKREF
         CALL LINE
         TYPE 10
  10     FORMAT(1H+,26HPICK A POINT OF REFERENCE.)
         CALL GRAFIN
         RETURN
      END

      SUBROUTINE SCALEM
         COMMON /GRP1/ RGX,RGY,J,N,ICHAR,IG,GX,GY,X(3000),Y(3000),I
     1   ,IROUTE
         COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
         REAL I(3000)
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         XTMP=X(J)
         X0=XO-XOFF
         Y0=YO-YOFF
         X(J)=X0+(X(J)+XOFF)*XMAG*CTHETA-(Y(J)+YOFF)*YMAG*STHETA
         Y(J)=Y0+(Y(J)+YOFF)*YMAG*CTHETA+(XTMP+XOFF)*XMAG*STHETA
         RETURN
      END

C         ACCEPT MAGNIFICATION VALUES.
      SUBROUTINE MAGGIN
         COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
         TYPE 10
  10     FORMAT(1H+,30HENTER MAGNIFICATIONS FOR X,Y: ,$)
         ACCEPT 20,XMAG,YMAG
  20     FORMAT(2G)
         IF (XMAG)30,40,50
  30     XMAG=-1./XMAG
         GO TO 50
  40     XMAG=1.
  50     IF (YMAG)60,70,80
  60     YMAG=-1./YMAG
         GO TO 80
  70     YMAG=1.
  80     CALL LINE
         RETURN
      END

C         ACCEPT ANGLE OF ROTATION.
      SUBROUTINE ROTOR
         COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
         TYPE 10
  10     FORMAT(1H+,21HDEGREES OF ROTATION: ,$)
         ACCEPT 20,THETA
  20     FORMAT(G)
         THETA=THETA/57.29578
         CTHETA=COS(THETA)
         STHETA=SIN(THETA)
         CALL LINE
         RETURN
      END

C         DISPLAY THE MENU
      SUBROUTINE MENON
         TYPE 10
  10     FORMAT(/,18H A "!" ALTERNATELY,/,16H ENABLES OR DIS-)
         TYPE 20
  20     FORMAT(16H ABLES THE MENU.)
         CALL MOVEA(0.,605.)
         CALL ANMODE
         TYPE 25
  25     FORMAT(1H+,15HOLD FILE (READ),/,16H NEW FILE(WRITE))
         TYPE 30
  30     FORMAT(16H JOIN FILE(READ),/,15H MAGNIFY (DATA))
         TYPE 35
  35     FORMAT(15H ROTATE  (DATA))
         TYPE 40
  40     FORMAT(15H POSITION(DATA),/,14H *ALL 3(ABOVE))
         TYPE 45
  45     FORMAT(15H X-SCALE (PLOT))
         TYPE 50
  50     FORMAT(15H Y-SCALE (PLOT),/,15H FRAME   (PLOT))
         TYPE 55
  55     FORMAT(15H POSITION(PLOT),/,14H TYPE OUT DATA)
         TYPE 60
  60     FORMAT(16H LIST (GRAPHICS),/,16H DELETE ELEMENTS,/,5H QUIT)
         RETURN
      END

C         GET A FIVE (OR LESS) LETTER NAME FOR A DISK FILE.
      SUBROUTINE GETNAM
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         TYPE 10
10       FORMAT(1H+,16HENTER FILENAME :,$)
         ACCEPT 20,NAME
20       FORMAT(A5)
         RETURN
      END


C         INITIALIZATION OF DATA SCALING PARAMETERS.
      SUBROUTINE INIT
         COMMON /GRP2/ XOFF,YOFF,XMAG,YMAG,CTHETA,STHETA,THETA,MRG,L2
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         XO=0
         YO=0
         XOFF=0
         YOFF=0
         XMAG=1.
         YMAG=1.
         CTHETA=1.
         STHETA=0
         THETA=0
         RETURN
      END

C         CHANGE ALL PLOT PARAMETERS TO YIELD UNITY SCALING.
      SUBROUTINE UNIT
         COMMON /GRP3/ XOFFP,YOFFP,XMAGP,YMAGP
         COMMON /GRP4/ YTMP,XOP,YOP,XO,YO,NAME
         XOP=0
         YOP=0
         XOFFP=0
         YOFFP=0
         XMAGP=1.
         YMAGP=1.
         RETURN
      END
