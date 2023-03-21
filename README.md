# STM32 library for HC-SR04 ultrasonic distance sensor

HC-SR04 is an ultrasonic sensor that measures distances from 2 to 400cm.

![HC-SR04](/hcsr04.jpeg)

This is a simple libray for it!

## Sensor specifications

- vcc to 5V
- trigger to GPIO_Point PG11
- echo to GPIO_Point PA6
- gnd to gnd


## Usage
Package Hcsr04 is elaborated at compile time that initialize the sensor. \
```c
package Hcsr04 is

   pragma Elaborate_Body;
   ...
end Hcsr04;

package body Hcsr04 is
  ...
begin
  HCSR04_New;
end Hcsr04;
```

Default value for maximum measurement distance is 4m, since HC-SR04 sensor can't measure reliably beyond that.

Then to measure the distance, you just call `measureDistanceCm()`, which will return distance in Cm.

If distance is larger than 400cm, it will return 0. (`Real`). The calculation assumes a temperature of around 20°C.


## Prerequesite (tested on linux ubuntu 22.04 )

**Alire**: <https://github.com/alire-project/alire/releases>

1. Download and unzip the latest linux zip
2. Add *where_you_unzipped/alr* to PATH.
3. Verify Alire is found on your path by running this command on your terminal:

    which alr

## OpenOCD

Here is a [very good tutorial](<https://youtu.be/-p26X8lTAvo>) on how to install openocd on ubuntu.


**STM32f429 Discovery board**\
\
![stm32f429disco](/stm32f429disco.jpeg)
* Plug it to your computer using the [USB MINI B cable](<https://fr.aliexpress.com/item/1005001942868270.html?algo_pvid=ca3f3071-36ed-4210-9a35-d2635ae72b56&algo_exp_id=ca3f3071-36ed-4210-9a35-d2635ae72b56-0&pdp_ext_f=%7B%22sku_id%22%3A%2212000018176126358%22%7D&pdp_npi=3%40dis%21XOF%211301.0%211042.0%21%21%21%21%21%402102172f16777957964894627d06fd%2112000018176126358%21sea%21SN%210&curPageLogUid=OkJbd81354FL>)


## Download 
if you don't have git yet, you can downloaded it [here](https://git-scm.com/downloads).

Then create a new folder or move in the directory of your choice and clone this repository by running:

    git clone https://github.com/bullyDD/hcsr04_stm32.git


## Build
Inside hcsr04_stm32 repo, run:

    alr build
    eval "$(alr printenv)"
    gprbuild hcrs04.gpr


## Build with gnatstudio
    gnatstudio hcrs04.gpr

## Run 
Now you can run the code on stm32f429 discovery board by running:

    openocd -f /usr/local/share/openocd/scripts/board/stm32f429disc1.cfg -c 'program bin/test verify reset exit' 
    
As result you should see distance on stm32f429disco lcd screen.




