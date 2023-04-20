with Ada.Unchecked_Conversion;

package body Hcsr04 is  

   ---------------------
   -- Initialize_Pins --
   ---------------------
   procedure Initialize_Pins is
   begin
      ------------------------
      --  Configure PWM Pin --
      Configure_PWM_Timer (Generator => Trigger_PWM_Timer'Access,
                           Frequency => PWM_Frequency);
     
      Attach_PWM_Channel 
        (This      => Trigger_PWM_Output,
         Generator => Trigger_PWM_Timer'Access,
         Channel   => Channel_1,
         Point     => Trigger_PWM_Pin,
         PWM_AF    => Trigger_Output_AF); 
      
      Set_Duty_Time (This  => Trigger_PWM_Output,
                     Value => 10);
      Enable_Output (This => Trigger_PWM_Output);
      -------------------------
      --  Configure echo pin --
      Configure_Channel_Input (This      => Echo_Pin_Timer,
                               Channel   => Channel_3,
                               Polarity  => Rising,
                               Selection => Direct_TI,
                               Prescaler => Div1,
                               Filter    => 0);
      --  Enable Timer
      Enable (This => Echo_Pin_Timer);
      --  Enable timer channel
      Enable_Channel (This    => Echo_Pin_Timer,
                      Channel => Channel_3);
      --  Enable interrupt on timer_5 for Input capture mode
      Enable_Interrupt (This   => Echo_Pin_Timer,
                        Source => Timer_CC3_Interrupt);
   end Initialize_Pins;
   ----------------
   -- Initialize --
   ----------------
   procedure Initialize is
      --  Port_Config : GPIO_Port_Configuration (Mode_AF);
   begin
      null;
      --  Set record components
      --  Port_Config.AF_Output_Type := Push_Pull;
      --  Port_Config.AF_Speed := Speed_100MHz;
      --  Port_Config.AF := Trigger_Output_AF;
      --  
      --  --  Enable GPIO
      --  Enable_Clock (Point => Trigger_PWM_Pin);
      --  Enable_Clock (This => Trigger_PWM_Timer);
      --  
      --  --  Configure GPIO
      --  Configure_IO (This   => Trigger_PWM_Pin,
      --                Config => Port_Config);
      --  
      --  --  Configure Timer
      --  Configure (This          => Trigger_PWM_Timer,
      --             Prescaler     => 8,
      --             Period        => 1,
      --             Clock_Divisor => Div1,
      --             Counter_Mode  => Up);
      --  
      --  --  Configure channel
      --  Configure_Channel_Input (This      => Trigger_PWM_Timer,
      --                           Channel   => Channel_1,
      --                           Polarity  => Rising,
      --                           Selection => Direct_TI,
      --                           Prescaler => Div8,
      --                           Filter    => 0);
      --  
      --  Enable_Channel (This    => Trigger_PWM_Timer,
      --                  Channel => Channel_1);
      --  Set_Counter (This  => Trigger_PWM_Timer,
      --               Value => UInt32 (0));
      --  Enable_Interrupt (This   => Trigger_PWM_Timer,
      --                    Source => Timer_CC1_Interrupt);
      --  Enable (This => Trigger_PWM_Timer);
   end Initialize;
   --------------
   -- Set_Duty --
   --------------
   procedure Set_Duty (Duty : STM32.PWM.Microseconds := UInt32 (0.01)) is
   begin
      Trigger_PWM_Output.Enable_Output;
      Trigger_PWM_Output.Set_Duty_Time (Duty);
   end Set_Duty;
   ----------------
   -- Is_Enabled --
   ----------------
   function Is_Enabled return Boolean is
      (Output_Enabled (Trigger_PWM_Output));
begin
   Initialize_Pins;
   -- Initialize;
end Hcsr04;
