# PicThrowDK
Different projects for pic16f or pic18f microntrollers
It depends on PicLibDK repository 

<keep in mind that this is work in progress>

1. LED segments example - 
    ![Pic16f628A Led segments circuit](16f628/led/photo_circuit.jpg)
    for pic16f628a, also pic16f913 
    look to specific folders

2. DS18B20 usage with one ds18b20
    ![Pic16f913 ds18b20 with led segments](16f913/ds18b20_with_led/ds18b20_16f913_example.jpg)
    for pic16f913 with one or multiple sensors connected on same pin.
    
3. DS18B20 with cheap pic16f913
    System is capable of detecting id of each of the connected sensors
    and based on that communicate with them. Temperature is shown on the screen one after one sensors (second 1 is information abour normal or parasite power - 1 
    means normal)    
    Symbol shows that measurement of second connected sensor will be displayed
    ![Ds18b20 second connected sensor](16f913/ds18b20_with_led/ds18b20_16f913_ds21.jpg)
    And is displayed
    ![Ds18b20 second connected sensor temperature](16f913/ds18b20_with_led/ds18b20_16f913_192.jpg)
    Symbol shows that measurement of 4th connected sensor will be displayed
    ![Ds18b20 second connected sensor](16f913/ds18b20_with_led/ds18b20_16f913_ds41.jpg)
    And is displayed
    ![Ds18b20 second connected sensor temperature](16f913/ds18b20_with_led/ds18b20_16f913_194.jpg)

4. LED segments example in 16f84a - small, old pic16f - not very useful, but I like it very much (emotional connection)
    ![Pic16f84a Led segments circuit ](16f84/led_example/led_segments.jpg)


