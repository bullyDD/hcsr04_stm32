with Ada.Real_Time;             use Ada.Real_Time;

package body Hcsr04.Interrupts is

   -------------
   -- Handler --
   -------------
   protected body Handler is
      -----------------
      -- IRQ_Handler --
      -----------------
      procedure IRQ_Hanlder is 
      begin
         -- IRQ_Enable  := Interrupt_Enabled (Echo_Pin_Timer, Timer_CC3_Interrupt);
         --  Can_Measure := Status (Timer_5, Timer_CC3_Indicated);
         if Status (Timer_5, Timer_CC3_Indicated) then
            if Interrupt_Enabled (Timer_5, Timer_CC3_Interrupt) then
               Clear_Pending_Interrupt (Timer_5, Timer_CC3_Interrupt);
               Can_Measure := Can_Measure + 1;
            end if;
         end if;
      end IRQ_Hanlder; 
      -----------------------
      -- MeasureDistanceCM --
      -----------------------
      function MeasureDistanceCM return Integer is
         Start_Time : constant Time := Clock;
         Distance   : Float;
      begin
         
         --  if Can_Measure then
         --     Clear_Pending_Interrupt (Timer_2, Timer_CC1_Interrupt);
         --     declare
         --        Stop_Time : Time;
         --        Timing    : Duration;
         --     begin
         --        Stop_Time := Clock;
         --        Timing := To_Duration (Stop_Time - Start_Time);
         --        Distance := Float (Timing) * 0.343 / 2.0;
         --     end;
         --     return Distance;
         --  else
         --     return 0.0;
         --  end if;
         return Can_Measure;

      end MeasureDistanceCM;
   end Handler;
end Hcsr04.Interrupts;
