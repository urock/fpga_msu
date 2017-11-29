create_ip -name fifo_generator -vendor xilinx.com -library ip -module_name uart_fifo

set_property -dict [list   CONFIG.INTERFACE_TYPE {AXI_STREAM} \
                           CONFIG.TUSER_WIDTH {0} \
                           CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} \
                           CONFIG.Input_Depth_axis {32} \
                           CONFIG.Reset_Type {Asynchronous_Reset} \
                           CONFIG.Full_Flags_Reset_Value {1} \
                           CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
                           CONFIG.Full_Threshold_Assert_Value_wach {15} \
                           CONFIG.Empty_Threshold_Assert_Value_wach {14} \
                           CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
                           CONFIG.Full_Threshold_Assert_Value_wrch {15} \
                           CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
                           CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
                           CONFIG.Full_Threshold_Assert_Value_rach {15} \
                           CONFIG.Empty_Threshold_Assert_Value_rach {14} \
                           CONFIG.Full_Threshold_Assert_Value_axis {31} \
                           CONFIG.Empty_Threshold_Assert_Value_axis {30}] [get_ips uart_fifo]