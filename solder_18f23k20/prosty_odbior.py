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
   
   temp_hex = linia[0]
   temp_hex = '0x'+temp_hex
   
   temp_dec = int(temp_hex,0)
   
   
   temp_hex = linia[1]
   temp_hex = '0x'+temp_hex
   
   temp_dec2 = int(temp_hex,0)
   
   pwm_hex = linia[3]
   pwm_hex = '0x'+pwm_hex
   
   pwm_dec = int(pwm_hex,0)
   
   pwm2_hex = linia[4]
   pwm2_hex = '0x'+pwm2_hex
   
   pwm2_dec = int(pwm2_hex,0)
   
   pwmI_hex = linia[5]
   if "-" in pwmI_hex:
        pwmI_hex = '-0x'+pwmI_hex[1:]
   else:
        pwmI_hex = '0x'+pwmI_hex
   
   
   pwmI_dec = int(pwmI_hex,0)
   
   
   temp_ds_hex = linia[2]
   temp_ds_hex = temp_ds_hex.split(".")
   
   
   temp_ds = '0x'+temp_ds_hex[0]
   temp_ds_01 = '0x'+temp_ds_hex[1]
   temp_ds = int(temp_ds,0)+ int(temp_ds_01,0)/16.
   
   dane = str(temp_dec) + "\t" 
   
   print " thermo 1 ",temp_dec,
   print " thermo 2 ",temp_dec2
   
   liczba_ref = (0.0409*temp_ds- 0.0051)*k/i
   
   temp_dec +=liczba_ref
   print " liczba thermo obl ",temp_dec
   # print " temp_dec ",temp_dec
   t_od = (24.472*temp_dec+0.1333)/k*i
   
   t_ob_przez_procesor = (24.472*temp_dec2+0.1333)/k*i
   
   
   
   print t_od," ","  ", t_ob_przez_procesor,"   ",temp_ds
   dane += str(temp_dec) + "\t" + str(t_od) + "\t" +  str(temp_dec2) +"\t" + str(t_ob_przez_procesor)
   dane += "\t" + str(temp_ds) + "\t" + str(pwm_dec)+"\t" + str(pwm2_dec)  + "\t" + str(pwmI_dec) 
   plik.write(str(time.time() - start ) +"\t"+dane + "\n")     
   
#ser.setRTS(1)
#time.sleep(10)
# ser.write("*P0\n")
#ser.setRTS(0)                           
           
print "koniec"                           
plik.close()
   
                  
 

