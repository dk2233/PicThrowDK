#!/usr/bin/python
# -*- coding: iso8859-2 -*- # 

import sys
import os
import time
import serial
import string


if len(sys.argv)>1:
         com_nr=float(sys.argv[1])
         plik=open(sys.argv[2],"w",5)
         plik2=open(sys.argv[2]+"2","w",5)
         
else:    
         print "give to options: com port number and file name "
         sys.exit()




         
ser=serial.Serial(port=(com_nr-1),baudrate=9600,bytesize=serial.EIGHTBITS,parity=serial.PARITY_NONE,stopbits=serial.STOPBITS_ONE,rtscts=0,xonxoff=0,timeout=3000,writeTimeout=50)
#19200
log=open("log","w",12)
 
koniec=0
poprzednie_wyswietlenie=time.time()
start=time.time()
print start


i= 2.45/4096*1000

k=160

while(koniec==0):
        #print self.koniec

        line=ser.readline()
        print time.time()-start,line
        # print str(os.times()[4]-start)
        print time.time()-start,
        line=line.strip()
        linia = line.split(",")
        print linia
        # print linia[0]," ",
        # print linia[1]," ",

        
        if "t" in line:
         
                if "-" in linia[2]:
                        
                        obl = int('0x'+linia[2][1:],0)
                        # obl = ~obl
                        obl = -obl
                        # obl = obl - 256
                else:
                        
                        
                        obl = int('0x'+linia[2],0)
                print " uchyb ",obl
                dane = str(obl)+"\t"
                
                
                if "-" in linia[3]:
                        
                        obl_kor = int('0x'+linia[3][1:],0)
                        obl_kor = obl_kor-256
                        # obl_kor = -obl_kor
                else:
                        
                        obl_kor = int('0x'+linia[3],0)
                dane += str(obl_kor)+"\t"
                print " czastka korekty ",obl_kor
           
                plik2.write(str(time.time() - start ) +"\t"+dane+"\n")
        else:   
                temp_hex = linia[1]
                temp_hex = '0x'+temp_hex
   
                temp_dec = int(temp_hex,0)
                t_obl = (24.472*temp_dec+0.1333)/k*i
                dane = str(t_obl)+"\t"
                obl = int('0x'+linia[4],0)
                # print "\n \t korekta ",obl,"  ",obl_kor/4.
                dane += str(obl)+"\t"
   
        
                plik.write(str(time.time() - start ) +"\t"+dane+"\n")
   
#ser.setRTS(1)
#time.sleep(10)
# ser.write("*P0\n")
#ser.setRTS(0)                           
           
print "koniec"                           
plik.close()
   
                  
 

