// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_top.h for the primary calling header

#include "Vcore_top.h"
#include "Vcore_top__Syms.h"

//==========

VL_CTOR_IMP(Vcore_top) {
    Vcore_top__Syms* __restrict vlSymsp = __VlSymsp = new Vcore_top__Syms(this, name());
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vcore_top::__Vconfigure(Vcore_top__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vcore_top::~Vcore_top() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vcore_top::_initial__TOP__1(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_initial__TOP__1\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->dmem_addr = 0ULL;
    vlTOPp->dmem_wdata = 0ULL;
    vlTOPp->dmem_wen = 0U;
    vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(1,32,32, 0x400U, vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i)) {
        vlTOPp->core_top__DOT__u_rom__DOT__mem[(0x3ffU 
                                                & vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i)] = 0x13U;
        vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i 
            = ((IData)(1U) + vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i);
    }
    vlTOPp->core_top__DOT__u_rom__DOT__mem[0U] = 0x500093U;
    vlTOPp->core_top__DOT__u_rom__DOT__mem[1U] = 0xa00113U;
    vlTOPp->core_top__DOT__u_rom__DOT__mem[2U] = 0x2081b3U;
}

void Vcore_top::_settle__TOP__3(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_settle__TOP__3\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->core_top__DOT__wb_final_data = ((IData)(vlTOPp->core_top__DOT__wb_mem_to_reg)
                                             ? vlTOPp->core_top__DOT__wb_mem_data
                                             : vlTOPp->core_top__DOT__wb_alu_result);
    vlTOPp->core_top__DOT__dec_alu_op = ((0x13U == 
                                          (0x7fU & vlTOPp->core_top__DOT__id_instr))
                                          ? ((0x4000U 
                                              & vlTOPp->core_top__DOT__id_instr)
                                              ? ((0x2000U 
                                                  & vlTOPp->core_top__DOT__id_instr)
                                                  ? 
                                                 ((0x1000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 9U
                                                   : 8U)
                                                  : 
                                                 ((0x1000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 
                                                  ((0x40000000U 
                                                    & vlTOPp->core_top__DOT__id_instr)
                                                    ? 7U
                                                    : 6U)
                                                   : 5U))
                                              : ((0x2000U 
                                                  & vlTOPp->core_top__DOT__id_instr)
                                                  ? 
                                                 ((0x1000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 4U
                                                   : 3U)
                                                  : 
                                                 ((0x1000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 2U
                                                   : 0U)))
                                          : ((0x33U 
                                              == (0x7fU 
                                                  & vlTOPp->core_top__DOT__id_instr))
                                              ? ((0x4000U 
                                                  & vlTOPp->core_top__DOT__id_instr)
                                                  ? 
                                                 ((0x2000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 
                                                  ((0x1000U 
                                                    & vlTOPp->core_top__DOT__id_instr)
                                                    ? 9U
                                                    : 8U)
                                                   : 
                                                  ((0x1000U 
                                                    & vlTOPp->core_top__DOT__id_instr)
                                                    ? 
                                                   ((0x40000000U 
                                                     & vlTOPp->core_top__DOT__id_instr)
                                                     ? 7U
                                                     : 6U)
                                                    : 5U))
                                                  : 
                                                 ((0x2000U 
                                                   & vlTOPp->core_top__DOT__id_instr)
                                                   ? 
                                                  ((0x1000U 
                                                    & vlTOPp->core_top__DOT__id_instr)
                                                    ? 4U
                                                    : 3U)
                                                   : 
                                                  ((0x1000U 
                                                    & vlTOPp->core_top__DOT__id_instr)
                                                    ? 2U
                                                    : 
                                                   ((0x40000000U 
                                                     & vlTOPp->core_top__DOT__id_instr)
                                                     ? 1U
                                                     : 0U))))
                                              : 0U));
    vlTOPp->core_top__DOT__dec_reg_write = ((0x13U 
                                             == (0x7fU 
                                                 & vlTOPp->core_top__DOT__id_instr)) 
                                            | (0x33U 
                                               == (0x7fU 
                                                   & vlTOPp->core_top__DOT__id_instr)));
    vlTOPp->core_top__DOT__dec_alu_src = 0U;
    if ((0x13U == (0x7fU & vlTOPp->core_top__DOT__id_instr))) {
        vlTOPp->core_top__DOT__dec_alu_src = 1U;
    } else {
        if ((0x33U == (0x7fU & vlTOPp->core_top__DOT__id_instr))) {
            vlTOPp->core_top__DOT__dec_alu_src = 0U;
        }
    }
    vlTOPp->imem_addr = vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr;
    vlTOPp->core_top__DOT__u_fetch__DOT__pc_next = 
        (4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr);
    vlTOPp->core_top__DOT__alu_operand_a = ((((IData)(vlTOPp->core_top__DOT__mem_reg_write) 
                                              & (0U 
                                                 != (IData)(vlTOPp->core_top__DOT__mem_rd_addr))) 
                                             & ((IData)(vlTOPp->core_top__DOT__mem_rd_addr) 
                                                == (IData)(vlTOPp->core_top__DOT__ex_rs1_addr)))
                                             ? vlTOPp->core_top__DOT__mem_alu_result
                                             : ((((IData)(vlTOPp->core_top__DOT__wb_reg_write) 
                                                  & (0U 
                                                     != (IData)(vlTOPp->core_top__DOT__wb_rd_addr))) 
                                                 & ((IData)(vlTOPp->core_top__DOT__wb_rd_addr) 
                                                    == (IData)(vlTOPp->core_top__DOT__ex_rs1_addr)))
                                                 ? vlTOPp->core_top__DOT__wb_final_data
                                                 : vlTOPp->core_top__DOT__ex_rs1_data));
    vlTOPp->core_top__DOT__alu_operand_b = ((IData)(vlTOPp->core_top__DOT__ex_alu_src)
                                             ? vlTOPp->core_top__DOT__ex_imm
                                             : ((((IData)(vlTOPp->core_top__DOT__mem_reg_write) 
                                                  & (0U 
                                                     != (IData)(vlTOPp->core_top__DOT__mem_rd_addr))) 
                                                 & ((IData)(vlTOPp->core_top__DOT__mem_rd_addr) 
                                                    == (IData)(vlTOPp->core_top__DOT__ex_rs2_addr)))
                                                 ? vlTOPp->core_top__DOT__mem_alu_result
                                                 : 
                                                ((((IData)(vlTOPp->core_top__DOT__wb_reg_write) 
                                                   & (0U 
                                                      != (IData)(vlTOPp->core_top__DOT__wb_rd_addr))) 
                                                  & ((IData)(vlTOPp->core_top__DOT__wb_rd_addr) 
                                                     == (IData)(vlTOPp->core_top__DOT__ex_rs2_addr)))
                                                  ? vlTOPp->core_top__DOT__wb_final_data
                                                  : vlTOPp->core_top__DOT__ex_rs2_data)));
    vlTOPp->core_top__DOT__alu_result = ((8U & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                          ? ((4U & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                              ? 0ULL
                                              : ((2U 
                                                  & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                  ? 0ULL
                                                  : 
                                                 ((1U 
                                                   & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                   ? 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   & vlTOPp->core_top__DOT__alu_operand_b)
                                                   : 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   | vlTOPp->core_top__DOT__alu_operand_b))))
                                          : ((4U & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                              ? ((2U 
                                                  & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                  ? 
                                                 ((1U 
                                                   & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                   ? 
                                                  VL_SHIFTRS_QQI(64,64,6, vlTOPp->core_top__DOT__alu_operand_a, 
                                                                 (0x3fU 
                                                                  & (IData)(vlTOPp->core_top__DOT__alu_operand_b)))
                                                   : 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   >> 
                                                   (0x3fU 
                                                    & (IData)(vlTOPp->core_top__DOT__alu_operand_b))))
                                                  : 
                                                 ((1U 
                                                   & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                   ? 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   ^ vlTOPp->core_top__DOT__alu_operand_b)
                                                   : 
                                                  ((vlTOPp->core_top__DOT__alu_operand_a 
                                                    < vlTOPp->core_top__DOT__alu_operand_b)
                                                    ? 1ULL
                                                    : 0ULL)))
                                              : ((2U 
                                                  & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                  ? 
                                                 ((1U 
                                                   & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                   ? 
                                                  (VL_LTS_IQQ(1,64,64, vlTOPp->core_top__DOT__alu_operand_a, vlTOPp->core_top__DOT__alu_operand_b)
                                                    ? 1ULL
                                                    : 0ULL)
                                                   : 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   << 
                                                   (0x3fU 
                                                    & (IData)(vlTOPp->core_top__DOT__alu_operand_b))))
                                                  : 
                                                 ((1U 
                                                   & (IData)(vlTOPp->core_top__DOT__ex_alu_op))
                                                   ? 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   - vlTOPp->core_top__DOT__alu_operand_b)
                                                   : 
                                                  (vlTOPp->core_top__DOT__alu_operand_a 
                                                   + vlTOPp->core_top__DOT__alu_operand_b)))));
}

void Vcore_top::_eval_initial(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval_initial\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst_n = vlTOPp->rst_n;
}

void Vcore_top::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::final\n"); );
    // Variables
    Vcore_top__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vcore_top::_eval_settle(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval_settle\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
}

void Vcore_top::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    rst_n = VL_RAND_RESET_I(1);
    imem_addr = VL_RAND_RESET_Q(64);
    imem_rdata = VL_RAND_RESET_I(32);
    dmem_addr = VL_RAND_RESET_Q(64);
    dmem_wdata = VL_RAND_RESET_Q(64);
    dmem_wen = VL_RAND_RESET_I(1);
    dmem_rdata = VL_RAND_RESET_Q(64);
    core_top__DOT__id_pc = VL_RAND_RESET_Q(64);
    core_top__DOT__id_instr = VL_RAND_RESET_I(32);
    core_top__DOT__dec_alu_op = VL_RAND_RESET_I(4);
    core_top__DOT__dec_reg_write = VL_RAND_RESET_I(1);
    core_top__DOT__dec_alu_src = VL_RAND_RESET_I(1);
    core_top__DOT__ex_rs1_data = VL_RAND_RESET_Q(64);
    core_top__DOT__ex_rs2_data = VL_RAND_RESET_Q(64);
    core_top__DOT__ex_imm = VL_RAND_RESET_Q(64);
    core_top__DOT__ex_rd_addr = VL_RAND_RESET_I(5);
    core_top__DOT__ex_alu_op = VL_RAND_RESET_I(4);
    core_top__DOT__ex_reg_write = VL_RAND_RESET_I(1);
    core_top__DOT__ex_alu_src = VL_RAND_RESET_I(1);
    core_top__DOT__ex_rs1_addr = VL_RAND_RESET_I(5);
    core_top__DOT__ex_rs2_addr = VL_RAND_RESET_I(5);
    core_top__DOT__alu_result = VL_RAND_RESET_Q(64);
    core_top__DOT__mem_alu_result = VL_RAND_RESET_Q(64);
    core_top__DOT__mem_rs2_data = VL_RAND_RESET_Q(64);
    core_top__DOT__mem_rd_addr = VL_RAND_RESET_I(5);
    core_top__DOT__mem_reg_write = VL_RAND_RESET_I(1);
    core_top__DOT__alu_operand_a = VL_RAND_RESET_Q(64);
    core_top__DOT__alu_operand_b = VL_RAND_RESET_Q(64);
    core_top__DOT__wb_alu_result = VL_RAND_RESET_Q(64);
    core_top__DOT__wb_mem_data = VL_RAND_RESET_Q(64);
    core_top__DOT__wb_final_data = VL_RAND_RESET_Q(64);
    core_top__DOT__wb_rd_addr = VL_RAND_RESET_I(5);
    core_top__DOT__wb_reg_write = VL_RAND_RESET_I(1);
    core_top__DOT__wb_mem_to_reg = VL_RAND_RESET_I(1);
    core_top__DOT__u_fetch__DOT__pc_next = VL_RAND_RESET_Q(64);
    core_top__DOT__u_fetch__DOT__pc_curr = VL_RAND_RESET_Q(64);
    { int __Vi0=0; for (; __Vi0<1024; ++__Vi0) {
            core_top__DOT__u_rom__DOT__mem[__Vi0] = VL_RAND_RESET_I(32);
    }}
    core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i = 0;
    { int __Vi0=0; for (; __Vi0<32; ++__Vi0) {
            core_top__DOT__u_regfile__DOT__regs[__Vi0] = VL_RAND_RESET_Q(64);
    }}
    core_top__DOT__u_regfile__DOT__unnamedblk1__DOT__i = 0;
    { int __Vi0=0; for (; __Vi0<2; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
