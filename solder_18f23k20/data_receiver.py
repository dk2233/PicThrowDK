#!/usr/bin/python
# -*- coding: iso8859-2 -*- # 

import sys
import os
import time
import serial
import string
from msvcrt import getch

if len(sys.argv)>1:
         com_nr=float(sys.argv[1])
         plik=open(sys.argv[2],"w",5)
         
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
   # print time.time()-start,line
   # print str(os.times()[4]-start)
   print time.time()-start,
   line=line.strip()
   linia = line.split(",")
   # print linia
   # print linia[0]," ",
   # print linia[1]," ",
   
   temp_hex = linia[0]
   temp_hex = '0x'+temp_hex
   
   temp_dec = int(temp_hex,0)
   
   
   
   
   pwm_hex = linia[1]
   pwm_hex = '0x'+pwm_hex
   
   pwm_dec = int(pwm_hex,0)
   
   
   dane = str(temp_dec) + "\t" 
   
   
   
   
   
   # print " liczba thermo obl ",temp_dec
   # print " temp_dec ",temp_dec
   t_od = (24.472*temp_dec+0.1333)/k*i
   
   # t_ob_przez_procesor = (24.472*temp_dec2+0.1333)/k*i
   
   
   
   print "  ",t_od," ","  ", pwm_dec
   dane +=  str(t_od) + "\t" + str(pwm_dec)
   plik.write(str(time.time() - start ) +"\t"+dane + "\n")     
   # key =sys.stdin.read(1)
   # getch()
   # print  key
   # if key=='q':
        # koniec=1
        
#ser.setRTS(1)
#time.sleep(10)
# ser.write("*P0\n")
#ser.setRTS(0)                           
           
print "koniec"                           
plik.close()
   
                  
 

