#### ASSEMBLER.AWK ####

################################
####     ERROR HANDLING     ####
################################

## E_MISSING_INT: @ -> error_msg to stderr and exit code = 1
## Purpose: to identify A instructions missing an integer following the '@'
## Example: @ should produce E_UNKNOWN_CMD > /dev/stderr and $?=1

{
    E_UNKNOWN_CMD_A = "This is not a valid .asm command. A instructions are of the form @XXX where XXX represent integers." 
    EX_UNKNOWN_A = 1 # Exit code for unknown A instruction 
}

/^@$/ { print E_UNKNOWN_CMD_A > "/dev/stderr" 
	exit EX_UNKNOWN_A }

## E_OUT_OF_RANGE: @ -> error_msq > stderr and exit code = 2
## Purpose: to identify A instructions which are greater than 24577; that is, out of range for the RAM
## Example: @30000 should produce E_OUT_OF_RANGE > /dev/stderr and $?=2

{
    E_OUT_OF_RANGE_MSG = "This A instruction is not a valid RAM address. It is out of range. Use an integer between 1 and 24576."
    EX_OUT_OF_RANGE = 2 # Exit code
}

### Match 24'577 - 99'999 and then anything with more than 6 digits. ###
### 1. Match 6 or more digits ###
/^\d{6,}$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

### 2. Match 30'000 to 99'999 ###
/^[3-9]\d{4,}$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

### 3. Match 25'000 to 29'999 ###
/^2[5-9]\d{3,}$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

### 4. Match 24'600 to 24'999 ###
/^24[6-9]\d{2,}$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

### 5. Match 24'570 to 24'599 ###
/^245[8-9]\d$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

### 6. Match 24'577 to 24'579 ###
/^2457[7-9]$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr"
     exit EX_OUT_OF_RANGE }

## LEADING_ZERO: @0... -> error_msq > stderr and exit code = 3
## Purpose: to identify A instructions which have a leading zero
## Example: @011 should produce E_LEADING_ZERO > /dev/stderr and $?=3
{
    E_LEADING_ZERO_MSG = "This A instruction has a leading zero, which is an invalid A instruction."
    EX_LEADING_ZERO = 3 # Exit code
}

/^0\d+$/ { print E_LEADING_ZERO_MSG > "/dev/stderr"
     exit EX_LEADING_ZERO }

## : @0... -> error_msq > stderr and exit code  = 2
## Purpose: to identify A instructions which are greater than 24576; that is, out of range for the RAM
## Example: @30000 should produce E_OUT_OF_RANGE > /dev/stderr and $?=2
{
    E_OUT_OF_RANGE_MSG = "This A instruction is not a valid RAM address. It is out of range. Use an integer between 1 and 24576."
    EX_OUT_OF_RANGE = 2 # Exit code
}

/^*\D*$/ { print E_OUT_OF_RANGE_MSG > "/dev/stderr" # Should match anything which contains a non-digit. Do I want to set a limit on symbol length?
     exit EX_OUT_OF_RANGE }
