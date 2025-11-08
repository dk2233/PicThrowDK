#!/usr/bin/python
# -*- coding: iso8859-2 -*- # 

import sys
import os
import time
import serial
import Tkinter
import threading
import thread
import string
#import Gnuplot,Gnuplot.funcutils



# dodano 2011.05.05
# tu jest mala poprawka w uzyciu tego programu w komunikacji z laptopem Toshiba - nie bardzo chcš działać 
# linie markerow komunikacyjnych - RTS i CTS
# ta wersja ma je wylaczone

#poprawki = [9,0,0,7,6,10,0]

global jak_czesto_na_ekran
jak_czesto_na_ekran=0
global miejsce_czasu
#gplot=Gnuplot.Gnuplot()
global ser



i= 2.45/4096*1000

k=160

class MyThread ( threading.Thread ):
         def stop(self):
                  print "koniec"
                  self._Thread__stop()
                  #thread.exit_thread()                  
         def run ( self):
                  self.koniec=0
                  self.poprzednie_wyswietlenie=time.time()
                  while(self.koniec==0):
                           
                           
                           line=ser.readline()
                           # print time.time()-start,line
                           # print str(os.times()[4]-start)
                           print time.time()-start,
                           line=line.strip()
                           linia = line.split(",")
                           
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
                           
                           if   plik:
                           
                                plik.write(str(time.time() - start ) +"\t"+dane + "\n")     
                                                   
                                    
                                    
                           
                  
                                   
                  print "koniec"                           
                  plik.close()
                           
                  
class MyApp:                        
         def __init__(self, parent):
                  self.a = 0
                  self.kanal="1"
                  self.czas="1"
                  self.srednia="1"
                  self.myParent=parent
                  self.myContainer1 = Tkinter.Frame(self.myParent)
                  #self.myContainer1.pack()
                  self.myContainer1.grid()
                  
                  self.button1 = Tkinter.Button(self.myContainer1)
                  self.button1["text"]= "Data Receiver"
                  self.button1["background"] = "green"
                  #self.button1.pack()
                  self.button1.grid(column=0,row=0)
                  self.button1.bind("<Button-1>",self.PushButton1)
                  
                  
                        
                  
                  
                  
                  self.button3 = Tkinter.Button(self.myContainer1)
                  self.button3.configure(text= "Quit")
                  #self.button3.pack(side=Tkinter.LEFT)
                  self.button3.grid(column=3,row=0)
                  self.button3.bind("<Button-1>",self.PushButton3)
                                                
                  
                  
                  self.lab1=Tkinter.Label(self.myParent, text="Com. port number")
                  #self.lab1.pack(side=Tkinter.LEFT)
                  self.lab1.grid(column=0,row=1)
                  self.listbox=Tkinter.Listbox(height=20)
                  for i in range (1,20):
                           self.listbox.insert(Tkinter.END, str(i))
                  #self.listbox.pack(side=Tkinter.LEFT)
                  self.listbox.grid(column=0,row=2)
                  self.listbox.bind("<ButtonRelease-1>",self.Wybor_1_listy)
                  
                  
                   
                  
                                                     
                   
                  self.entry1=Tkinter.Entry()
                  self.entry1.insert(Tkinter.END,"podaj nazwe pliku")
                  #self.entry1.pack(side=Tkinter.LEFT)
                  
                  self.entry1.grid(column=2,row=1)
                  self.entry1.bind("<Return>",self.Przyjmij_Tekst)
                  
                  
                  
                  self.znacznik_zapisu=Tkinter.StringVar()
                  #self.znacznik_zapisu="a"
                  self.radion_button1=Tkinter.Radiobutton(self.myParent,text="continuar proyecto",variable=self.znacznik_zapisu,value="a",command=self.wypisz)
                  self.radion_button1.grid(column=2,row=3)
                  self.radion_button2=Tkinter.Radiobutton(self.myParent,text="nuavo proyecto",variable=self.znacznik_zapisu,value="w",command=self.wypisz)
                  self.radion_button2.grid(column=2,row=4)
                  
          

         def wypisz(self):
                 self.znacznik_zapisue=self.znacznik_zapisu.get()
                 print self.znacznik_zapisu.get()
                  #," ",self.znacznik_zapisu.get()
                  
         def PushButton1(self,event):
                 global ser
                 port_numer = int(self.numer)-1
                 ser=serial.Serial(port=port_numer,baudrate=9600,bytesize=serial.EIGHTBITS,parity=serial.PARITY_NONE,stopbits=serial.STOPBITS_ONE,rtscts=0,xonxoff=0,timeout=3000,writeTimeout=50)
                  
                 print " opened port number ",port_numer
                 
         
                  
         def PushButton3(self,event):
                  print "Bye" 
                  
                  try:
                        if ser:
                                
                           ser.close()
                  except:
                        pass
                           
                  log.close()
                  if dir('__main__')=="plik":
                           print "jest otwarty"
                           plik.close()
                        
                  #self.pomiary.koniec=1
                  print __name__
                  try:
                           if self.pomiary.isAlive():
                                    print "wciaz zyje"
                                    self.pomiary.stop()
                  except:
                           # print "error" 
                           pass
                  self.myParent.destroy()
                  
                  
                  sys.exit() 
                  
         def Wybor_1_listy(self,event):
                  self.numer=self.listbox.selection_get()
                  print self.numer
                  #self.a=self.listbox2.curselection()
                  #print self.a
        
         def Przyjmij_Tekst(self,event):
                  global start
                  global plik
                  #global gplot
                  global war
                  #global koniec
                  start=time.time()
                  #os.times()[4]
                  nazwa_pliku=self.entry1.get()
                  print nazwa_pliku," jako :",self.znacznik_zapisu.get()
                  
                  plik=open(nazwa_pliku,self.znacznik_zapisu.get(),12)
                  #wykonaj="ser2.py "+str(plik)
                  #os.popen3(wykonaj)
                  #war=Gnuplot.File(str(nazwa_pliku),with="line",using="1:2")
                  try:
                           if self.pomiary.isAlive():
                                             print "wciaz zyje"
                                             self.pomiary.stop()
                  except:
                           pass                                             
                  self.pomiary=MyThread()
                  self.pomiary.start()
         def Przyjmij_Czas(self,event):
                  self.czas=self.entry0.get()         
                  
          
if __name__=="__main__":    
         
      
         
         
         #19200
         log=open("log","w",12)
         
              
         root = Tkinter.Tk()
         myapp = MyApp(root)
         #root.after(100,dane_z_portu)
         root.mainloop()
      
