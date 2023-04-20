with Ada.Interrupts.Names;        use Ada.Interrupts.Names;

package Hcsr04.Interrupts is

   protected Handler is
      pragma Interrupt_Priority;
      procedure IRQ_Hanlder;
      function MeasureDistanceCM return Integer;
   private
      IRQ_Enable  : Boolean;
      Can_Measure : Integer;      
      pragma Attach_Handler (IRQ_Hanlder, TIM5_Interrupt);
   end Handler;

end Hcsr04.Interrupts;
