-------------------------------------------------------------
-- Task Test:                                              --
-- Every 500 miliseconds, do a measurement using the sensor-- 
-- and print the distance in centimeters.                  --
-------------------------------------------------------------
with Hcsr04_Pkg;   use Hcsr04_Pkg;

with Ada.Real_Time; use Ada.Real_Time;

with LCD_Std_Out;  use LCD_Std_Out;
with HAL.Framebuffer;  use HAL.Framebuffer;


procedure Test is
   D : Real := 0.0;
   Period : Time_Span := Milliseconds (500);
   Next   : Time      := Clock;

begin
   D := MeasureDistanceCm;
   Clear_Screen;
   Set_Orientation (Landscape);
   Put_Line ("Dist = " & D'Image);
   Next := Next + Period;
   delay until Next;
   
   -- Block MCU in infinite loop
   loop
      null;
   end loop;
   
end Test;
