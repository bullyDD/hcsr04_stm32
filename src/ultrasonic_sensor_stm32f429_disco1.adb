with Hcsr04;              use Hcsr04;
with Hcsr04.Interrupts;   use Hcsr04.Interrupts;

with Ada.Real_Time; use Ada.Real_Time;
with LCD_Std_Out;   use LCD_Std_Out;

procedure Ultrasonic_Sensor_Stm32f429_Disco1 is
   State  : Boolean;
   Dist   : Integer;
begin
   --  Initialize_PWM_Pin;
   State := Is_Enabled;
   Clear_Screen;
   Put_Line ("Pin state: " & State'Image);
   delay 1.5;
   Clear_Screen;

   loop
      Dist := Handler.MeasureDistanceCM;
      Put_Line ("Dist= " & Dist'Image);
   end loop;

end Ultrasonic_Sensor_Stm32f429_Disco1;
