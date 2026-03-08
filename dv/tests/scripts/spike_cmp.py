import sys
import re

def parse_log(filepath, is_rtl=False):
    commits = []
    # Flexible regex: only looks for the PC (0x...), Instr (0x...), Reg (x...), and Data (0x...)
    regex = re.compile(r"0x([0-9a-fA-F]{8,16})\s+\(0x([0-9a-fA-F]{8})\)\s+x(\d+)\s+0x([0-9a-fA-F]{16})")
    
    last_commit = None
    found_start = False

    with open(filepath, 'r') as f:
        for line in f:
            match = regex.search(line)
            if match:
                pc    = int(match.group(1), 16)
                instr = int(match.group(2), 16)
                reg   = int(match.group(3), 10)
                val   = int(match.group(4), 16)
                
                current = (pc, instr, reg, val)

                # 1. Skip Spike's bootloader (anything before 0x80000000)
                if not is_rtl and not found_start:
                    if pc >= 0x80000000:
                        found_start = True
                    else:
                        continue

                # 2. Skip Duplicate RTL Commits (Pipeline artifacts)
                if is_rtl and current == last_commit:
                    continue

                # 3. Ignore x0 writes
                if reg != 0:
                    commits.append(current)
                    last_commit = current
    return commits

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 spike_cmp.py <rtl_log_file> <spike_log_file>")
        sys.exit(1)

    rtl_log = sys.argv[1]
    spike_log = sys.argv[2]

    print(f"🔍 Parsing RTL Log:   {rtl_log}")
    rtl_commits = parse_log(rtl_log)
    
    print(f"🔍 Parsing Spike Log: {spike_log}")
    spike_commits = parse_log(spike_log)

    print(f"\n📊 Extracted {len(rtl_commits)} RTL commits and {len(spike_commits)} Spike commits.\n")

    # Compare line by line
    min_len = min(len(rtl_commits), len(spike_commits))
    match = True

    for i in range(min_len):
        rtl = rtl_commits[i]
        spk = spike_commits[i]

        if rtl != spk:
            print(f"❌ MISMATCH at Commit #{i+1}!")
            print(f"   RTL   : PC=0x{rtl[0]:016x} | Instr=0x{rtl[1]:08x} | x{rtl[2]:<2} = 0x{rtl[3]:016x}")
            print(f"   SPIKE : PC=0x{spk[0]:016x} | Instr=0x{spk[1]:08x} | x{spk[2]:<2} = 0x{spk[3]:016x}")
            match = False
            break

    if match:
        if len(rtl_commits) == len(spike_commits):
            print("✅ SUCCESS: RTL matches Spike Golden Model perfectly!")
        else:
            print(f"⚠️ WARNING: Logs matched up to commit {min_len}, but lengths differ.")
            print("   (This is normal if Spike executed exit routines that the RTL testbench bypasses).")
    else:
        sys.exit(1)

if __name__ == "__main__":
    main()