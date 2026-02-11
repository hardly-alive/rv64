// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_top.h for the primary calling header

#include "Vcore_top.h"
#include "Vcore_top__Syms.h"

//==========

void Vcore_top::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcore_top::eval\n"); );
    Vcore_top__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rtl/core/core_top.sv", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vcore_top::_eval_initial_loop(Vcore_top__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rtl/core/core_top.sv", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vcore_top::_sequent__TOP__2(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_sequent__TOP__2\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    CData/*4:0*/ __Vdlyvdim0__core_top__DOT__u_regfile__DOT__regs__v0;
    CData/*0:0*/ __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v0;
    CData/*0:0*/ __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v1;
    QData/*63:0*/ __Vdlyvval__core_top__DOT__u_regfile__DOT__regs__v0;
    // Body
    __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v0 = 0U;
    __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v1 = 0U;
    if ((1U & (~ (IData)(vlTOPp->rst_n)))) {
        vlTOPp->core_top__DOT__u_regfile__DOT__unnamedblk1__DOT__i = 0x20U;
    }
    if (vlTOPp->rst_n) {
        vlTOPp->core_top__DOT__ex_alu_op = vlTOPp->core_top__DOT__dec_alu_op;
        vlTOPp->core_top__DOT__id_pc = vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr;
        vlTOPp->core_top__DOT__ex_alu_src = ((IData)(vlTOPp->core_top__DOT__dec_alu_src) 
                                             & 1U);
        vlTOPp->core_top__DOT__ex_rs1_addr = (0x1fU 
                                              & (vlTOPp->core_top__DOT__id_instr 
                                                 >> 0xfU));
        vlTOPp->core_top__DOT__ex_rs2_addr = (0x1fU 
                                              & (vlTOPp->core_top__DOT__id_instr 
                                                 >> 0x14U));
        vlTOPp->core_top__DOT__ex_imm = (((0x13U == 
                                           (0x7fU & vlTOPp->core_top__DOT__id_instr)) 
                                          | (3U == 
                                             (0x7fU 
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
                                          : 0ULL);
    } else {
        vlTOPp->core_top__DOT__ex_alu_op = 0U;
        vlTOPp->core_top__DOT__id_pc = 0ULL;
        vlTOPp->core_top__DOT__ex_alu_src = 0U;
        vlTOPp->core_top__DOT__ex_rs1_addr = 0U;
        vlTOPp->core_top__DOT__ex_rs2_addr = 0U;
        vlTOPp->core_top__DOT__ex_imm = 0ULL;
    }
    vlTOPp->core_top__DOT__wb_mem_to_reg = 0U;
    vlTOPp->core_top__DOT__wb_mem_data = 0ULL;
    if (vlTOPp->rst_n) {
        vlTOPp->core_top__DOT__wb_alu_result = vlTOPp->core_top__DOT__mem_alu_result;
        vlTOPp->core_top__DOT__ex_rs1_data = ((0U == 
                                               (0x1fU 
                                                & (vlTOPp->core_top__DOT__id_instr 
                                                   >> 0xfU)))
                                               ? 0ULL
                                               : ((
                                                   ((0x1fU 
                                                     & (vlTOPp->core_top__DOT__id_instr 
                                                        >> 0xfU)) 
                                                    == (IData)(vlTOPp->core_top__DOT__wb_rd_addr)) 
                                                   & (IData)(vlTOPp->core_top__DOT__wb_reg_write))
                                                   ? vlTOPp->core_top__DOT__wb_final_data
                                                   : 
                                                  vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                                  [
                                                  (0x1fU 
                                                   & (vlTOPp->core_top__DOT__id_instr 
                                                      >> 0xfU))]));
        vlTOPp->core_top__DOT__mem_rs2_data = vlTOPp->core_top__DOT__ex_rs2_data;
    } else {
        vlTOPp->core_top__DOT__wb_alu_result = 0ULL;
        vlTOPp->core_top__DOT__ex_rs1_data = 0ULL;
        vlTOPp->core_top__DOT__mem_rs2_data = 0ULL;
    }
    if (vlTOPp->rst_n) {
        if (((IData)(vlTOPp->core_top__DOT__wb_reg_write) 
             & (0U != (IData)(vlTOPp->core_top__DOT__wb_rd_addr)))) {
            __Vdlyvval__core_top__DOT__u_regfile__DOT__regs__v0 
                = vlTOPp->core_top__DOT__wb_final_data;
            __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v0 = 1U;
            __Vdlyvdim0__core_top__DOT__u_regfile__DOT__regs__v0 
                = vlTOPp->core_top__DOT__wb_rd_addr;
        }
    } else {
        __Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v1 = 1U;
    }
    if (vlTOPp->rst_n) {
        vlTOPp->core_top__DOT__mem_alu_result = vlTOPp->core_top__DOT__alu_result;
        vlTOPp->core_top__DOT__ex_rs2_data = ((0U == 
                                               (0x1fU 
                                                & (vlTOPp->core_top__DOT__id_instr 
                                                   >> 0x14U)))
                                               ? 0ULL
                                               : ((
                                                   ((0x1fU 
                                                     & (vlTOPp->core_top__DOT__id_instr 
                                                        >> 0x14U)) 
                                                    == (IData)(vlTOPp->core_top__DOT__wb_rd_addr)) 
                                                   & (IData)(vlTOPp->core_top__DOT__wb_reg_write))
                                                   ? vlTOPp->core_top__DOT__wb_final_data
                                                   : 
                                                  vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                                  [
                                                  (0x1fU 
                                                   & (vlTOPp->core_top__DOT__id_instr 
                                                      >> 0x14U))]));
    } else {
        vlTOPp->core_top__DOT__mem_alu_result = 0ULL;
        vlTOPp->core_top__DOT__ex_rs2_data = 0ULL;
    }
    if (__Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v0) {
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[__Vdlyvdim0__core_top__DOT__u_regfile__DOT__regs__v0] 
            = __Vdlyvval__core_top__DOT__u_regfile__DOT__regs__v0;
    }
    if (__Vdlyvset__core_top__DOT__u_regfile__DOT__regs__v1) {
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[1U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[2U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[3U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[4U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[5U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[6U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[7U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[8U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[9U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xaU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xbU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xcU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xdU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xeU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0xfU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x10U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x11U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x12U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x13U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x14U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x15U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x16U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x17U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x18U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x19U] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1aU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1bU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1cU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1dU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1eU] = 0ULL;
        vlTOPp->core_top__DOT__u_regfile__DOT__regs[0x1fU] = 0ULL;
    }
    vlTOPp->core_top__DOT__wb_final_data = ((IData)(vlTOPp->core_top__DOT__wb_mem_to_reg)
                                             ? vlTOPp->core_top__DOT__wb_mem_data
                                             : vlTOPp->core_top__DOT__wb_alu_result);
    vlTOPp->core_top__DOT__wb_reg_write = ((IData)(vlTOPp->rst_n) 
                                           & (IData)(vlTOPp->core_top__DOT__mem_reg_write));
    if (vlTOPp->rst_n) {
        vlTOPp->core_top__DOT__wb_rd_addr = vlTOPp->core_top__DOT__mem_rd_addr;
        vlTOPp->core_top__DOT__mem_reg_write = ((IData)(vlTOPp->core_top__DOT__ex_reg_write) 
                                                & 1U);
        vlTOPp->core_top__DOT__mem_rd_addr = vlTOPp->core_top__DOT__ex_rd_addr;
        vlTOPp->core_top__DOT__ex_reg_write = ((IData)(vlTOPp->core_top__DOT__dec_reg_write) 
                                               & 1U);
    } else {
        vlTOPp->core_top__DOT__wb_rd_addr = 0U;
        vlTOPp->core_top__DOT__mem_reg_write = 0U;
        vlTOPp->core_top__DOT__mem_rd_addr = 0U;
        vlTOPp->core_top__DOT__ex_reg_write = 0U;
    }
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
    vlTOPp->core_top__DOT__ex_rd_addr = ((IData)(vlTOPp->rst_n)
                                          ? (0x1fU 
                                             & (vlTOPp->core_top__DOT__id_instr 
                                                >> 7U))
                                          : 0U);
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
    vlTOPp->core_top__DOT__id_instr = ((IData)(vlTOPp->rst_n)
                                        ? vlTOPp->core_top__DOT__u_rom__DOT__mem
                                       [(0x3ffU & (IData)(
                                                          (vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr 
                                                           >> 2U)))]
                                        : 0x13U);
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
    vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr = 
        ((IData)(vlTOPp->rst_n) ? vlTOPp->core_top__DOT__u_fetch__DOT__pc_next
          : 0ULL);
    vlTOPp->imem_addr = vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr;
    vlTOPp->core_top__DOT__u_fetch__DOT__pc_next = 
        (4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr);
}

void Vcore_top::_eval(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if ((((IData)(vlTOPp->clk) & (~ (IData)(vlTOPp->__Vclklast__TOP__clk))) 
         | ((~ (IData)(vlTOPp->rst_n)) & (IData)(vlTOPp->__Vclklast__TOP__rst_n)))) {
        vlTOPp->_sequent__TOP__2(vlSymsp);
        vlTOPp->__Vm_traceActivity[1U] = 1U;
    }
    // Final
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst_n = vlTOPp->rst_n;
}

VL_INLINE_OPT QData Vcore_top::_change_request(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_change_request\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vcore_top::_change_request_1(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_change_request_1\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vcore_top::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
}
#endif  // VL_DEBUG
