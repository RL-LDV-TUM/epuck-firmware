cmake_minimum_required(VERSION 3.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

project(LDV-EPUCK-FW C ASM)

find_file(XC16_BIN2HEX xc16-bin2hex)
message(STATUS "Found bin2hex: ${XC16_BIN2HEX}")


set(CMAKE_C_FLAGS "-mcpu=${CMAKE_SYSTEM_PROCESSOR} -mlarge-code -mlarge-data -O0 -fmessage-length=0")
# The asm compiler is invoked via gcc, so we can just keep the flags. Otherwise, -mcpu would be mandatory
set(CMAKE_ASM_FLAGS ${CMAKE_C_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--heap=128,--stack=512,--report-mem,-Map=${CMAKE_PROJECT_NAME}.map,--script=/usr/local/share/microchip/xc16/v1.22/support/dsPIC30F/gld/p30F6014A.gld")

set(CMAKE_VERBOSE_MAKEFILE ON)

set(LIB_PATH "../../library/")
include_directories(
    ${LIB_PATH}
    # The asm compiler apparently doesn't look for includes in the same dir
    # as the source file, so we include them explicitly
    ${LIB_PATH}/uart
    ${LIB_PATH}/codec
    )

set(LDV-EPUCK-FW_SOURCES
    main_c.c
    Asercom.c
    DataEEPROM.s
    runaccelerometer.c
    runbreitenberg_adv.c
    rungrounddirection.c
    rungyroscope.c
    runlocatesound.c
    runshow.c
    runsquare.c
    runwallfollow.c
    translatorI2C.c
    ${LIB_PATH}/acc_gyro/e_lsm330.c
    ${LIB_PATH}/a_d/advance_ad_scan/e_acc.c
    ${LIB_PATH}/a_d/advance_ad_scan/e_ad_conv.c
    ${LIB_PATH}/a_d/advance_ad_scan/e_micro.c
    ${LIB_PATH}/a_d/advance_ad_scan/e_prox.c
    ${LIB_PATH}/bluetooth/e_bluetooth.c
    ${LIB_PATH}/camera/fast_2_timer/e_calc_po3030k.c
    ${LIB_PATH}/camera/fast_2_timer/e_calc_po6030k.c
    ${LIB_PATH}/camera/fast_2_timer/e_calc_po8030d.c
    ${LIB_PATH}/camera/fast_2_timer/e_common.c
    ${LIB_PATH}/camera/fast_2_timer/e_interrupt.s
    ${LIB_PATH}/camera/fast_2_timer/e_po3030k_registers.c
    ${LIB_PATH}/camera/fast_2_timer/e_po6030k_registers.c
    ${LIB_PATH}/camera/fast_2_timer/e_po8030d_registers.c
    ${LIB_PATH}/camera/fast_2_timer/e_timers.c
    ${LIB_PATH}/codec/e_const_sound.s
    ${LIB_PATH}/codec/e_init_codec_slave.s
    ${LIB_PATH}/codec/e_init_dci_master.s
    ${LIB_PATH}/codec/e_sound.c
    ${LIB_PATH}/codec/e_sub_dci_kickoff.s
    ${LIB_PATH}/I2C/e_I2C_master_module.c
    ${LIB_PATH}/I2C/e_I2C_protocol.c
    ${LIB_PATH}/motor_led/advance_one_timer/e_agenda.c
    ${LIB_PATH}/motor_led/advance_one_timer/e_led.c
    ${LIB_PATH}/motor_led/advance_one_timer/e_motors.c
    ${LIB_PATH}/motor_led/advance_one_timer/e_remote_control.c
    ${LIB_PATH}/motor_led/e_init_port.c
    ${LIB_PATH}/uart/e_init_uart1.s
    ${LIB_PATH}/uart/e_init_uart2.s    
    ${LIB_PATH}/uart/e_uart1_rx_char.s
    ${LIB_PATH}/uart/e_uart1_tx_char.s
    ${LIB_PATH}/uart/e_uart2_rx_char.s
    ${LIB_PATH}/uart/e_uart2_tx_char.s    
    ${LIB_PATH}/utility/utility.c
    )

add_executable("${CMAKE_PROJECT_NAME}.elf" ${LDV-EPUCK-FW_SOURCES})

add_custom_target(
    "${CMAKE_PROJECT_NAME}.hex" ALL
    ${XC16_BIN2HEX} "${CMAKE_PROJECT_NAME}.elf"
    COMMENT "Creating .hex file for flashing the e-puck"
    DEPENDS LDV-EPUCK-FW.elf)

set(EXTRA_TO_CLEAN_FILES
    ${CMAKE_PROJECT_NAME}.hex
    ${CMAKE_PROJECT_NAME}.map
    )
set_directory_properties(PROPERTY ADDITIONAL_MAKE_CLEAN_FILES "${EXTRA_TO_CLEAN_FILES}")
