// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcore_top__Syms.h"


void Vcore_top::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vcore_top::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[0U])) {
            tracep->chgIData(oldp+0,(vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgQData(oldp+1,(vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr),64);
            tracep->chgIData(oldp+3,(vlTOPp->core_top__DOT__u_rom__DOT__mem
                                     [(0x3ffU & (IData)(
                                                        (vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr 
                                                         >> 2U)))]),32);
            tracep->chgQData(oldp+4,(vlTOPp->core_top__DOT__id_pc),64);
            tracep->chgIData(oldp+6,(vlTOPp->core_top__DOT__id_instr),32);
            tracep->chgCData(oldp+7,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0xfU))),5);
            tracep->chgCData(oldp+8,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0x14U))),5);
            tracep->chgCData(oldp+9,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 7U))),5);
            tracep->chgQData(oldp+10,((((0x13U == (0x7fU 
                                                   & vlTOPp->core_top__DOT__id_instr)) 
                                        | (3U == (0x7fU 
                                                  & vlTOPp->core_top__DOT__id_instr)))
                                        ? ((0xfffffffffffff000ULL 
                                            & ((- (QData)((IData)(
                                                                  (1U 
                                                                   & (vlTOPp->core_top__DOT__id_instr 
                                                                      >> 0x1fU))))) 
                                               << 0xcU)) 
                                           | (QData)((IData)(
                                                             (0xfffU 
                                                              & (vlTOPp->core_top__DOT__id_instr 
                                                                 >> 0x14U)))))
                                        : 0ULL)),64);
            tracep->chgCData(oldp+12,(vlTOPp->core_top__DOT__dec_alu_op),4);
            tracep->chgBit(oldp+13,(vlTOPp->core_top__DOT__dec_reg_write));
            tracep->chgBit(oldp+14,(vlTOPp->core_top__DOT__dec_alu_src));
            tracep->chgQData(oldp+15,(((0U == (0x1fU 
                                               & (vlTOPp->core_top__DOT__id_instr 
                                                  >> 0xfU)))
                                        ? 0ULL : vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                       [(0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                                  >> 0xfU))])),64);
            tracep->chgQData(oldp+17,(((0U == (0x1fU 
                                               & (vlTOPp->core_top__DOT__id_instr 
                                                  >> 0x14U)))
                                        ? 0ULL : vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                       [(0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                                  >> 0x14U))])),64);
            tracep->chgQData(oldp+19,(vlTOPp->core_top__DOT__ex_rs1_data),64);
            tracep->chgQData(oldp+21,(vlTOPp->core_top__DOT__ex_rs2_data),64);
            tracep->chgQData(oldp+23,(vlTOPp->core_top__DOT__ex_imm),64);
            tracep->chgCData(oldp+25,(vlTOPp->core_top__DOT__ex_rd_addr),5);
            tracep->chgCData(oldp+26,(vlTOPp->core_top__DOT__ex_alu_op),4);
            tracep->chgBit(oldp+27,(vlTOPp->core_top__DOT__ex_reg_write));
            tracep->chgBit(oldp+28,(vlTOPp->core_top__DOT__ex_alu_src));
            tracep->chgQData(oldp+29,(vlTOPp->core_top__DOT__alu_operand_b),64);
            tracep->chgQData(oldp+31,(vlTOPp->core_top__DOT__alu_result),64);
            tracep->chgQData(oldp+33,((4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr)),64);
            tracep->chgCData(oldp+35,((0x7fU & vlTOPp->core_top__DOT__id_instr)),7);
            tracep->chgCData(oldp+36,((7U & (vlTOPp->core_top__DOT__id_instr 
                                             >> 0xcU))),3);
            tracep->chgCData(oldp+37,((0x7fU & (vlTOPp->core_top__DOT__id_instr 
                                                >> 0x19U))),7);
            tracep->chgQData(oldp+38,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[0]),64);
            tracep->chgQData(oldp+40,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[1]),64);
            tracep->chgQData(oldp+42,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[2]),64);
            tracep->chgQData(oldp+44,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[3]),64);
            tracep->chgQData(oldp+46,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[4]),64);
            tracep->chgQData(oldp+48,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[5]),64);
            tracep->chgQData(oldp+50,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[6]),64);
            tracep->chgQData(oldp+52,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[7]),64);
            tracep->chgQData(oldp+54,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[8]),64);
            tracep->chgQData(oldp+56,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[9]),64);
            tracep->chgQData(oldp+58,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[10]),64);
            tracep->chgQData(oldp+60,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[11]),64);
            tracep->chgQData(oldp+62,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[12]),64);
            tracep->chgQData(oldp+64,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[13]),64);
            tracep->chgQData(oldp+66,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[14]),64);
            tracep->chgQData(oldp+68,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[15]),64);
            tracep->chgQData(oldp+70,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[16]),64);
            tracep->chgQData(oldp+72,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[17]),64);
            tracep->chgQData(oldp+74,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[18]),64);
            tracep->chgQData(oldp+76,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[19]),64);
            tracep->chgQData(oldp+78,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[20]),64);
            tracep->chgQData(oldp+80,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[21]),64);
            tracep->chgQData(oldp+82,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[22]),64);
            tracep->chgQData(oldp+84,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[23]),64);
            tracep->chgQData(oldp+86,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[24]),64);
            tracep->chgQData(oldp+88,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[25]),64);
            tracep->chgQData(oldp+90,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[26]),64);
            tracep->chgQData(oldp+92,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[27]),64);
            tracep->chgQData(oldp+94,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[28]),64);
            tracep->chgQData(oldp+96,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[29]),64);
            tracep->chgQData(oldp+98,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[30]),64);
            tracep->chgQData(oldp+100,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[31]),64);
            tracep->chgIData(oldp+102,(vlTOPp->core_top__DOT__u_regfile__DOT__unnamedblk1__DOT__i),32);
        }
        tracep->chgBit(oldp+103,(vlTOPp->clk));
        tracep->chgBit(oldp+104,(vlTOPp->rst_n));
        tracep->chgQData(oldp+105,(vlTOPp->imem_addr),64);
        tracep->chgIData(oldp+107,(vlTOPp->imem_rdata),32);
        tracep->chgQData(oldp+108,(vlTOPp->dmem_addr),64);
        tracep->chgQData(oldp+110,(vlTOPp->dmem_wdata),64);
        tracep->chgBit(oldp+112,(vlTOPp->dmem_wen));
        tracep->chgQData(oldp+113,(vlTOPp->dmem_rdata),64);
    }
}

void Vcore_top::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
