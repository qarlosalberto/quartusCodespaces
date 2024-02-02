// Copyright(c) 2021, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#include "sys/intel_fpga_api_cmn_dfl.h"
#include "sys/intel_fpga_api_cmn_msg.h"
#include "sys/intel_fpga_api_cmn_inf.h"

#define PARAM_HEADER_SIZE 8 // 8-byte parameter header
#define DFH_PARENT_STACK_INCR_SIZE 8

typedef unsigned int FPGA_INTERFACE_PARAM_BLOCK_INDEX;
typedef unsigned int FPGA_INTERFACE_PARAM_DATA_INDEX;

static int dfh_parent_stack_isempty();
static int dfh_parent_stack_peek();
static void dfh_parent_stack_pop();
static void dfh_parent_stack_push(int data);
static void dfh_parent_stack_resize(size_t size);
static void scan_the_num_interfaces(void *first_dfh_addr);
static void dfl_collect_interfaces_info(void *first_dfh_addr);
static uint64_t get_x_feature_dfh_start_64_data(void *current_dfh_address);
static bool is_eol(uint64_t dfh_64_data);
static void *get_next_dfh_addr(uint64_t dfh_64_data, void *current_dfh_address);
static uint64_t get_x_feature_csr_group_size_64_data(void *current_dfh_address);
static uint64_t get_next_param_byte_offset(uint64_t param_header_64_data);
static uint64_t get_x_feature_guid_l_64(void *current_dfh_address);
static uint64_t get_x_feature_guid_h_64(void *current_dfh_address);
static uint32_t get_next_dfh_byte_offset(uint64_t dfh_64_data);
static void *get_first_param_header_addr(void *dfh_base_addr);
static uint32_t get_param_id(uint64_t param_header_64_data);
static uint16_t get_param_block_version(uint64_t param_header_64_data);
static uint16_t get_param_block_param_id(uint64_t param_header_64_data);
static uint16_t get_instance_id(void *current_dfh_address);
static uint16_t get_group_id(void *current_dfh_address);
static void *get_base_address(void *current_dfh_address);
static bool has_params(uint64_t csr_size_group_64_data);
static void handle_well_known_param_id(void *current_dfh_addr, void *current_param_block_addr, int param_id, bool collect_interfaces);
static void process_param_list_for_known_param_id(void *current_dfh_addr, void *current_param_block_addr, bool collect_interfaces);
static void deal_with_interface_at_current_level(void *current_dfh_addr, bool collect_interfaces);
static void param_block_init(FPGA_INTERFACE_INDEX index);
static void param_block_resize(FPGA_INTERFACE_INDEX index, size_t size);
static void param_data_allocate(FPGA_INTERFACE_INDEX index, FPGA_INTERFACE_PARAM_BLOCK_INDEX param_block_index, size_t size);
static void set_parameter_properties(FPGA_INTERFACE_INDEX index, void *dfh_addr);
static void set_interface_properties(FPGA_INTERFACE_INDEX index, void *dfh_addr);
void dfl_walker_clean_up(); // celan up memory allocated for parameter block;

static int s_scanned_interface_count;
static int s_interface_index = 0;

// used to get the dfh_parent info
typedef struct
{
    int *head;
    int top;
    int size;
} DFH_PARENT_STACK;

const DFH_PARENT_STACK DFH_PARENT_STACK_default = {
    .head = NULL,
    .top = -1,
    .size = 0};

DFH_PARENT_STACK dfh_parent_stack;

static void dfh_parent_stack_resize(size_t size)
{
    if (size > (size_t)dfh_parent_stack.size)
    {
        dfh_parent_stack.head = realloc(dfh_parent_stack.head, size * sizeof(int));
        if (dfh_parent_stack.head == NULL)
        {
            fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "insufficient memory for %d DFH Parent Stack.", size);
        }
        else
        {
            memset(dfh_parent_stack.head + dfh_parent_stack.size, 0, ((size - dfh_parent_stack.size) * sizeof(int)));
            dfh_parent_stack.size = size;
        }
    }
    else if (size == 0)
    {
        if (dfh_parent_stack.head != NULL)
        {
            free(dfh_parent_stack.head);
        }
        dfh_parent_stack.head = NULL;
        dfh_parent_stack.size = 0;
    }
    else if (size < dfh_parent_stack.size)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "Truncating parameter DFH Parent Stack size is not allowed");
    }
}

static int dfh_parent_stack_isempty()
{
    if (dfh_parent_stack.top == -1)
        return 1;
    else
        return 0;
}

static int dfh_parent_stack_peek()
{
    return dfh_parent_stack.head[dfh_parent_stack.top];
}

static void dfh_parent_stack_pop()
{
    if (!dfh_parent_stack_isempty())
    {
        dfh_parent_stack.top = dfh_parent_stack.top - 1;
    }
    else
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "Could not retrieve data from DFH Parent Stack, Stack is empty");
    }
}

static void dfh_parent_stack_push(int data)
{
    if (dfh_parent_stack.top == dfh_parent_stack.size)
    {
        dfh_parent_stack_resize(dfh_parent_stack.size + DFH_PARENT_STACK_INCR_SIZE);
    }

    dfh_parent_stack.top = dfh_parent_stack.top + 1;
    dfh_parent_stack.head[dfh_parent_stack.top] = data;
}

void common_dfl_scan_multi_interfaces(void *first_dfh_addr, FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder)
{
    s_scanned_interface_count = 0;
    common_fpga_interface_info_vec_resize(s_scanned_interface_count);
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Start Scanning Interface...");
#endif
    scan_the_num_interfaces(first_dfh_addr);
    common_fpga_interface_info_vec_resize(s_scanned_interface_count);
#ifdef DFL_WALKER_DEBUG_MODE
#endif
    s_interface_index = -1;
    dfl_collect_interfaces_info(first_dfh_addr);

    dfh_parent_stack_resize(0); // free allocated for dfh_parent_stack

#ifdef DFL_WALKER_REPORT
    fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "===========================");
    fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "MMIO Interface(s) registered: %d", common_fpga_interface_info_vec_size());
    common_dfl_print_all_interfaces(base_addr_decoder);
#endif
}

static void scan_the_num_interfaces(void *first_dfh_addr)
{
    bool collect_interfaces = false;
    void *current_dfh_addr = first_dfh_addr;

    dfh_parent_stack_push(-1);      // used to track parent dfe
    deal_with_interface_at_current_level(current_dfh_addr, collect_interfaces);
}

static void dfl_collect_interfaces_info(void *first_dfh_addr)
{
    bool collect_interfaces = true;
    void *current_dfh_addr = first_dfh_addr;

    dfh_parent_stack_push(-1);
    common_fpga_interface_info_vec_resize(common_fpga_interface_info_vec_size());
    deal_with_interface_at_current_level(current_dfh_addr, collect_interfaces);
}

static void deal_with_interface_at_current_level(void *current_dfh_addr, bool collect_interfaces)
{
    if (!collect_interfaces)
    {
        // first walk to get interface count
        s_scanned_interface_count++;
    }
    else
    {
        // second walk to collect interface infomation into FPGA_INTERFACE_INFO struct
        s_interface_index++;
        set_interface_properties(s_interface_index, current_dfh_addr);
    }

#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "--------------------INTERFACE DIVIDER--------------------", current_dfh_addr);
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Current DFL Address: 0x%lX", current_dfh_addr);
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "GUID_L associated with DFH address 0x%lX = 0x%016llX", current_dfh_addr, get_x_feature_guid_l_64(current_dfh_addr));
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "GUID_H associated with DFH address 0x%lX = 0x%016llX", current_dfh_addr, get_x_feature_guid_h_64(current_dfh_addr));
#endif

    // walk through the param list in that interface
    uint64_t csr_size_group_64_data = get_x_feature_csr_group_size_64_data(current_dfh_addr);

#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "64-bit csr size group data associated with DFH address 0x%lX = 0x%016llX", current_dfh_addr, csr_size_group_64_data);
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "has_params = %d", has_params(csr_size_group_64_data));
#endif

    if (has_params(csr_size_group_64_data))
    {
        void *current_param_block_addr = get_first_param_header_addr(current_dfh_addr);

        // deal with current parameter block address
        process_param_list_for_known_param_id(current_dfh_addr, current_param_block_addr, collect_interfaces);
    }

    // check current dfh header to see if next dfh exist
    uint64_t dfh_start_64_data = get_x_feature_dfh_start_64_data(current_dfh_addr);
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "dfh_start_64_data is 0x%016llX", dfh_start_64_data);
#endif

    if (!is_eol(dfh_start_64_data))
    {

        // if not the end of the dfh list, get the next dfh address
        current_dfh_addr = get_next_dfh_addr(dfh_start_64_data, current_dfh_addr);
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Next dfh_addr is 0x%lX", current_dfh_addr);
#endif
        // deal with next interface
        deal_with_interface_at_current_level(current_dfh_addr, collect_interfaces);
    }
    else
    {
        // reached the end of the interface list at current level
        dfh_parent_stack_pop();
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Reached the end of current level DFL");
#endif
    }
}

static uint64_t get_x_feature_dfh_start_64_data(void *current_dfh_address)
{
    const uint32_t X_FEATURE_DFH_START_OFFSET = 0x00;
    uint64_t x_feature_dfh_start_64_data = common_dfl_read_64(current_dfh_address, X_FEATURE_DFH_START_OFFSET);

    return x_feature_dfh_start_64_data;
}

static bool is_eol(uint64_t dfh_start_64_data)
{
    return (dfh_start_64_data & 0x0000010000000000) > 0;
}

static uint32_t get_next_dfh_byte_offset(uint64_t dfh_start_64_data)
{
    return (uint32_t)((dfh_start_64_data & 0x0000007fffff0000) >> 16);
}

static void *get_next_dfh_addr(uint64_t dfh_start_64_data, void *current_dfh_address)
{
    uint32_t next_dfh_byte_offset = get_next_dfh_byte_offset(dfh_start_64_data);
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Current_DFH Address: 0x%lX; Next DFH offset is: 0x%lX", current_dfh_address, next_dfh_byte_offset);
#endif
    return (void *)((char *)current_dfh_address + next_dfh_byte_offset);
}

static uint64_t get_x_feature_guid_l_64(void *current_dfh_address)
{
    const uint32_t X_FEATURE_GUID_L_OFFSET = 0x08;
    return common_dfl_read_64(current_dfh_address, X_FEATURE_GUID_L_OFFSET);
}

static uint64_t get_x_feature_guid_h_64(void *current_dfh_address)
{
    const uint32_t X_FEATURE_GUID_H_OFFSET = 0x10;
    return common_dfl_read_64(current_dfh_address, X_FEATURE_GUID_H_OFFSET);
}

static FPGA_INTERFACE_GUID get_x_feature_guid_128(void *dfh_addr)
{
    FPGA_INTERFACE_GUID guid;
    guid.guid_h = get_x_feature_guid_h_64(dfh_addr);
    guid.guid_l = get_x_feature_guid_l_64(dfh_addr);

    return guid;
}


static uint64_t get_x_feature_csr_group_size_64_data(void *current_dfh_address)
{
    const uint32_t X_FEATURE_CSR_GROUP_SIZE_OFFSET = 0x20;
    uint64_t x_feature_csr_group_size_64_data = common_dfl_read_64(current_dfh_address, X_FEATURE_CSR_GROUP_SIZE_OFFSET);

    return x_feature_csr_group_size_64_data;
}

static uint16_t get_instance_id(void *current_dfh_address)
{
    uint64_t x_feature_csr_group_size_64_data = get_x_feature_csr_group_size_64_data(current_dfh_address);
    return (uint16_t)(x_feature_csr_group_size_64_data & 0x000000000000ffff);
}

static uint16_t get_group_id(void *current_dfh_address)
{
    uint64_t x_feature_csr_group_size_64_data = get_x_feature_csr_group_size_64_data(current_dfh_address);
    return (uint16_t)((x_feature_csr_group_size_64_data & 0x000000007fff0000) >> 16);
}

static void *get_first_param_header_addr(void *dfh_base_addr)
{
    const uint32_t PARAM_HEADER_OFFSET = 0x28;
    void *first_param_header_addr = (uint8_t *)dfh_base_addr + PARAM_HEADER_OFFSET;

    return first_param_header_addr;
}

static bool is_last_param_block(uint64_t param_header_64_data)
{
    bool is_last = (param_header_64_data >> 32) & 0b1;

    return is_last;
}
static uint64_t get_next_param_byte_offset(uint64_t param_header_64_data)
{
    uint64_t param_offset_in_64b_word = param_header_64_data >> 35;

    return param_offset_in_64b_word << 3;
}

static uint16_t get_param_block_version(uint64_t param_header_64_data)
{
    return (uint16_t)((param_header_64_data >> 16) & 0xFFFF);
}

static uint16_t get_param_block_param_id(uint64_t param_header_64_data)
{
    return (uint16_t)(param_header_64_data & 0xFFFF);
}

/*
resize parameter data under current param_block
size in number of bytes
*/
static void param_data_allocate(FPGA_INTERFACE_INDEX index, FPGA_INTERFACE_PARAM_BLOCK_INDEX param_block_index, size_t size)
{
    if (size % sizeof(uint64_t) != 0)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "DFH parameter data size, %d, is not multiple of 8.", size);
    }

    // malloc first param block
    common_fpga_interface_info_vec_at(index)->parameters[param_block_index].data = (uint64_t *)malloc(size);
    if (common_fpga_interface_info_vec_at(index)->parameters[param_block_index].data == NULL)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "Out of memory for parameter data.");
    }
    common_fpga_interface_info_vec_at(index)->parameters[param_block_index].data_size = size;
}

static void param_data_copy(FPGA_INTERFACE_INDEX index, FPGA_INTERFACE_PARAM_BLOCK_INDEX param_block_index, uint64_t *param_data_addr)
{
    size_t param_64_data_count = common_fpga_interface_info_vec_at(index)->parameters[param_block_index].data_size / sizeof(uint64_t);
    for (int i = 0; i < param_64_data_count; ++i, ++param_data_addr)
    {
        uint64_t data = common_dfl_read_64(param_data_addr, 0);
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "parameter block %d data @ index %d (addr: %lX): 0x%016llX", param_block_index, i, param_data_addr, data);
#endif
        common_fpga_interface_info_vec_at(index)->parameters[param_block_index].data[i] = data;
    }
}

static void *get_base_address(void *current_dfh_address)
{
    const uint32_t X_FEATURE_CSR_ADDRESS_OFFSET = 0x18;
    uint64_t csr_addr = (common_dfl_read_64(current_dfh_address, X_FEATURE_CSR_ADDRESS_OFFSET));
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "CSR address: 0x%llX", csr_addr);
#endif
    bool is_absolute_addr = 0b1 & csr_addr;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
    if (is_absolute_addr)
    {
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "CSR address is ABSOLUTE");
#endif
        return (void *)(csr_addr & 0xFFFFFFFFFFFFFFFE);
    }
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "CSR address is RELATIVE");
#endif

    return (void *)((uint64_t)current_dfh_address + (int64_t)csr_addr);
#pragma GCC diagnostic pop
}

static bool has_params(uint64_t csr_size_group_64_data)
{
    return (csr_size_group_64_data & 0x0000000080000000) > 0;
}

static uint32_t get_param_id(uint64_t param_header_64_data)
{
    return (param_header_64_data & 0x000000000000FFFF);
}

static void handle_branch_param_id(void *current_dfh_addr, void *current_param_block_addr, bool collect_interfaces)
{
    const uint32_t PARAM_DATA_OFFSET = 0x8;

    dfh_parent_stack_push(s_interface_index);
    // valid branch data
    uint64_t branch_dfl_64_data = common_dfl_read_64(current_param_block_addr, PARAM_DATA_OFFSET);
#ifdef DFL_WALKER_DEBUG_MODE
    const uint32_t BRANCH_DFL_SIZE_OFFSET = 0x10;
    uint32_t branch_dfl_size = common_dfl_read_32(current_param_block_addr, BRANCH_DFL_SIZE_OFFSET); // not used right now
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "branch_dfl_64_data: 0x%016llX", branch_dfl_64_data);
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "branch_dfl_size: 0x%X", branch_dfl_size);
#endif
    // check branch address: relative or absolute
    bool is_absolute = branch_dfl_64_data & 0b1;
    void *next_level_dfl_start_address;
    if (is_absolute)
    {
        // branch to next level dfl using absolute address
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
        next_level_dfl_start_address = (void *)(branch_dfl_64_data & 0xFFFFFFFFFFFFFFF8);
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "next_level_dfl_start_address: 0x%lX", next_level_dfl_start_address);
#endif
    }
    else
    {
        // branch to next level dfl using relative address (signed offset from dfh start)
        next_level_dfl_start_address = (void *)((int64_t)current_dfh_addr + (int64_t)(branch_dfl_64_data & 0xFFFFFFFFFFFFFFF8));
#pragma GCC diagnostic pop
        // branch to next level dfl
#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "next_level_dfl_start_address: 0x%lX", next_level_dfl_start_address);
#endif
    }
    deal_with_interface_at_current_level(next_level_dfl_start_address, collect_interfaces);
}

static void handle_well_known_param_id(void *current_dfh_addr, void *current_param_block_addr, int param_id, bool collect_interfaces)
{
    
    if (param_id == 0xc)
    {
        handle_branch_param_id(current_dfh_addr, current_param_block_addr, collect_interfaces);
    }
    else
    {
        // other paramter ID ...
    }
}

static void process_param_list_for_known_param_id(void *current_dfh_addr, void *current_param_block_addr, bool collect_interfaces)
{
#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "----------PARAMETER BLOCK DIVIDER----------", current_dfh_addr);
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "Scanning Parameter Under DFH address 0x%lX", current_dfh_addr);
#endif

    FPGA_INTERFACE_PARAM_BLOCK_INDEX param_block_index = 0;

    void *next_param_block_addr;
    uint32_t param_id;
    uint64_t param_header_64_data = common_dfl_read_64(current_param_block_addr, 0);

    // parameter list is terminated by a NULL parameter block with eop == 1 and no parameter data
    while (!is_last_param_block(param_header_64_data) || get_next_param_byte_offset(param_header_64_data) > 0)
    {
        param_id = get_param_id(param_header_64_data);

#ifdef DFL_WALKER_DEBUG_MODE
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "param_header_64_data at address 0x%lX = 0x%016llX", current_param_block_addr, param_header_64_data);
        fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "param_id: 0x%lX", param_id);
#endif

        // based on parameter ID, decide branch or do other stuff
        handle_well_known_param_id(current_dfh_addr, current_param_block_addr, param_id, collect_interfaces);

        // If this is last param block, don't advance to read next param block.
        if (!is_last_param_block(param_header_64_data))
        {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
            next_param_block_addr = (void *)((uint64_t)current_param_block_addr + get_next_param_byte_offset(param_header_64_data));
#pragma GCC diagnostic pop

#ifdef DFL_WALKER_DEBUG_MODE
            fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "current_param_block_addr: 0x%lX", current_param_block_addr);
            fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "next_param_block_offset in bytes: 0x%lX", next_param_block_addr);
#endif

            // check next param block
            param_header_64_data = common_dfl_read_64(next_param_block_addr, 0);
            current_param_block_addr = next_param_block_addr;
            param_block_index++;
        }
        else
        {
            break;
        }
    }

#ifdef DFL_WALKER_DEBUG_MODE
    fpga_msg_printf(FPGA_MSG_PRINTF_DEBUG, "reached NULL parameter block at address: 0x%lX", current_param_block_addr);
#endif

}

/*
initlaize the parameter block under current interface, should only be called once per interface
*/
static void param_block_init(FPGA_INTERFACE_INDEX index)
{
    // malloc first param block
    common_fpga_interface_info_vec_at(index)->parameters = (FPGA_INTERFACE_PARAMETER *)malloc(sizeof(FPGA_INTERFACE_PARAMETER));
    if (common_fpga_interface_info_vec_at(index)->parameters == NULL)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "insufficient memory for first interfaces.");
    }
    common_fpga_interface_info_vec_at(index)->num_of_parameters = 1;
}

/*
resize parameter block under current interface
size in number of parameter blocks
*/
static void param_block_resize(FPGA_INTERFACE_INDEX index, size_t size)
{
    if (size > common_fpga_interface_info_vec_at(index)->num_of_parameters)
    {
        common_fpga_interface_info_vec_at(index)->parameters = realloc(common_fpga_interface_info_vec_at(index)->parameters, size * sizeof(FPGA_INTERFACE_PARAMETER));
        if (common_fpga_interface_info_vec_at(index)->parameters == NULL)
        {
            fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "insufficient memory for %d parameter blocks.", size);
        }
        else
        {
            memset(common_fpga_interface_info_vec_at(index)->parameters + common_fpga_interface_info_vec_at(index)->num_of_parameters, 0, 
            (size - common_fpga_interface_info_vec_at(index)->num_of_parameters) * sizeof(FPGA_INTERFACE_PARAMETER));
            common_fpga_interface_info_vec_at(index)->num_of_parameters = size;
        }
    }
    else if (size == 0)
    {
        if (common_fpga_interface_info_vec_at(index)->parameters != NULL)
        {
            free(common_fpga_interface_info_vec_at(index)->parameters);
        }
        common_fpga_interface_info_vec_at(index)->parameters = NULL;
        common_fpga_interface_info_vec_at(index)->num_of_parameters = 0;
    }
    else if (size < common_fpga_interface_info_vec_at(index)->num_of_parameters)
    {
        fpga_throw_runtime_exception(__FUNCTION__, __FILE__, __LINE__, "truncating parameter block size is not allowed");
    }
}

/*
add parameter block information under current interface
index: interface index number
dfh_addr: current interface dfh_address
*/
static void set_parameter_properties(FPGA_INTERFACE_INDEX index, void *dfh_addr)
{
    uint64_t csr_size_group_64_data = get_x_feature_csr_group_size_64_data(dfh_addr);

    if (has_params(csr_size_group_64_data))
    {
        FPGA_INTERFACE_PARAM_BLOCK_INDEX param_block_index = 0;

        size_t param_data_size;
        void *next_param_block_addr;
        void *current_param_block_addr = get_first_param_header_addr(dfh_addr);
        uint64_t param_header_64_data = common_dfl_read_64(current_param_block_addr, 0);

        // parameter list is terminated by a NULL parameter block with eop == 1 and no parameter data
        while (!is_last_param_block(param_header_64_data) || get_next_param_byte_offset(param_header_64_data) > 0)
        {
            if ( param_block_index == 0)
            {
                param_block_init(index);
            }
            common_fpga_interface_info_vec_at(index)->parameters[param_block_index].version = get_param_block_version(param_header_64_data);
            common_fpga_interface_info_vec_at(index)->parameters[param_block_index].param_id = get_param_block_param_id(param_header_64_data);

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"

#ifdef DFL_WALKER_DEBUG_MODE
            common_fpga_interface_info_vec_at(index)->parameters[param_block_index].current_param_addr = (uint64_t)current_param_block_addr;
#endif
            if (is_last_param_block(param_header_64_data))
            {
                param_data_size = get_next_param_byte_offset(param_header_64_data); // If EOP bit is set, the size is the byte offset.
            }
            else
            {
                param_data_size = get_next_param_byte_offset(param_header_64_data) - PARAM_HEADER_SIZE;            
            }
            param_data_allocate(index, param_block_index, param_data_size);
            void *param_data_start_addr = (void *)((uint64_t)current_param_block_addr + PARAM_HEADER_SIZE);
            param_data_copy(index, param_block_index, param_data_start_addr);

            // If this is last param block, don't advance to read next param block.
            if (!is_last_param_block(param_header_64_data))
            {
                next_param_block_addr = (void *)((uint64_t)current_param_block_addr + get_next_param_byte_offset(param_header_64_data));
#ifdef DFL_WALKER_DEBUG_MODE
                common_fpga_interface_info_vec_at(index)->parameters[param_block_index].next_param_addr = (uint64_t)next_param_block_addr;
#endif
#pragma GCC diagnostic pop
                // check next param block
                param_header_64_data = common_dfl_read_64(next_param_block_addr, 0);
                current_param_block_addr = next_param_block_addr;
                param_block_index++;
                param_block_resize(index, (param_block_index + 1));
            }
            else
            {
#ifdef DFL_WALKER_DEBUG_MODE
                common_fpga_interface_info_vec_at(index)->parameters[param_block_index].next_param_addr = 0;
#endif
                break;
            }
        }
    }
}

static void set_interface_properties(FPGA_INTERFACE_INDEX index, void *dfh_addr)
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wint-to-pointer-cast"
    common_fpga_interface_info_vec_at(index)->base_address = (void *)((char *)get_base_address(dfh_addr));
#pragma GCC diagnostic pop
    common_fpga_interface_info_vec_at(index)->guid = get_x_feature_guid_128(dfh_addr);
    common_fpga_interface_info_vec_at(index)->instance_id = get_instance_id(dfh_addr);
    common_fpga_interface_info_vec_at(index)->group_id = get_group_id(dfh_addr);
    common_fpga_interface_info_vec_at(index)->dfh_parent = dfh_parent_stack_peek();
    common_fpga_interface_info_vec_at(index)->is_mmio_opened = false;
    common_fpga_interface_info_vec_at(index)->is_interrupt_opened = false;
    set_parameter_properties(index, dfh_addr);
}

void common_dfl_print_all_interfaces(FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder)
{
    size_t num_intf = common_fpga_interface_info_vec_size();
    for(size_t i = 0; i < num_intf; ++i)
    {
        common_dfl_print_interface(i, base_addr_decoder);
    }
}

void common_dfl_print_interface(FPGA_INTERFACE_INDEX index, FPGA_DFL_BASE_ADDR_DECODER base_addr_decoder)
{
    if (index < common_fpga_interface_info_vec_size() && index >= 0)
    {
        fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "   ---------- Interface %d ----------", index);
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
        fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "   Base Address: 0x%llX", base_addr_decoder((uint64_t)common_fpga_interface_info_vec_at(index)->base_address));
#pragma GCC diagnostic pop
        fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "   128-bit GUID: 0x%016llX%016llX", common_fpga_interface_info_vec_at(index)->guid.guid_h, common_fpga_interface_info_vec_at(index)->guid.guid_l);
        fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "   Instance ID: %d", common_fpga_interface_info_vec_at(index)->instance_id);
        fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "   Group ID: %d", common_fpga_interface_info_vec_at(index)->group_id);

        for (int i = 0; i < common_fpga_interface_info_vec_at(index)->num_of_parameters; i++)
        {
            fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "      ------ Parameter %d ------   ", i);
            fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "      Version: %d", common_fpga_interface_info_vec_at(index)->parameters[i].version);
            fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "      Param ID: %d", common_fpga_interface_info_vec_at(index)->parameters[i].param_id);
            fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "      Param Data Size: %d", common_fpga_interface_info_vec_at(index)->parameters[i].data_size);

            for (int j = 0; j < common_fpga_interface_info_vec_at(index)->parameters[i].data_size / sizeof(uint64_t); j++)
            {
                fpga_msg_printf(FPGA_MSG_PRINTF_INFO, "      64-bit Param Data[%d]: 0x%016llX", j, common_fpga_interface_info_vec_at(index)->parameters[i].data[j]);
            }
        }
    }
    else
    {
        fpga_msg_printf(FPGA_MSG_PRINTF_ERROR, "Please enter a valid interface index, acceptable index < %d", common_fpga_interface_info_vec_size());
    }
}
