
	list p=16f913
	include	"p16f913.inc"
        include ../../PicLibDK/stacks/macro_stack_operation.inc

     global stack_push_to, stack_pop

stack_space  udata 
stack_sp  res 1
stack_area  res .20

stack_code    code 
stack_push_to  

    m_push_to_stack stack_area, stack_sp, 0
    return 

stack_pop
    m_pop_stack stack_area, stack_sp 
    return 

    END
    