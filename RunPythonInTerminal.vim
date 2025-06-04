""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Function:
"     Execute the current Python script file in a terminal
" Definition:
"     RunPythonInTerminal(runstyle)
" Parameters:
"     runstyle: script execution mode
"        0 - Execute in a horizontally split terminal within the current tab, return to original window after completion
"        1 - Execute in a new terminal tab, stay in the terminal window after completion
" History:
"     Mar/04/2024    ,louis   ,New
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunPythonInTerminal(runstyle)
   " Unnamed files will automatically generate a temporary file (named files will be saved)
   if bufname('%') == ''
      let l:tempfile = tempname() . '.py'
      execute ':write! ' . l:tempfile
   else
      if &readonly == 0 | execute ':write' | endif
   endif

   " Get the current buffer's file name
   if bufname('%') == ''
      echohl ErrorMsg | echo "ERROR: Failed to get current file name, please save the file first" | echohl None
      return
   else
      if fnamemodify(expand('%'),':e') != 'py'
         echohl ErrorMsg | echo "ERROR: Only Python files (*.py) are supported" | echohl None
         return
      endif
      let l:filename = expand('%:p')
   endif

   " Get current tabpage and window number
   "let l:current_tabpage_number = tabpagenr()
   let l:current_win_number = winnr() 
   
   " Check if there is a terminal window meeting the required conditions
   if a:runstyle == 0
      " <F5>: Check if the current tab already has a terminal window (if multiple, get the smallest window number)
      let l:term_win_id = -1
      for win_id in range(1, winnr('$'))
         if getwinvar(win_id, '&buftype') == 'terminal' 
            if term_getstatus(winbufnr(win_id)) == 'running'
               let l:job = term_getjob(winbufnr(win_id))
               let l:jobinfo = job_info(l:job)
               let l:jobinfocmd=join(jobinfo.cmd, " ")
               if l:jobinfocmd=~ 'cmd.exe' || l:jobinfocmd=~ 'powershell' || l:jobinfocmd=~ 'bash'
                  let l:term_win_id = win_id
                  let l:term_cmd = l:jobinfocmd
                  break
               endif
            endif         
         endif
      endfor

      " Create a new terminal window (if none exists in the current tabpage)
      if l:term_win_id == -1
         terminal ++rows=8
         " Get the current terminal command
         let l:term_cmd = join(job_info(term_getjob(bufnr())).cmd, ' ')
      else
         " Switch to the terminal window found
         execute l:term_win_id . 'wincmd w'
      endif
   else
      " <F8>: If there exists a tabpage with only one terminal window in the current Vim session,
      " get that window's information (tab ID / window ID (1) / terminal command)
      let l:target_tab_number=-1
      for page_id in range(1, tabpagenr('$')) 
         if tabpagewinnr(page_id, '$') == 1 && gettabwinvar(page_id,1,'&buftype') == 'terminal'
            " Must enter the tabpage to get further information
            execute 'tabnext ' . page_id
            if term_getstatus(winbufnr(1)) == 'running'
               let l:jobinfocmd=join(job_info(term_getjob(buffer_number())).cmd, " ")
               if l:jobinfocmd=~ 'cmd.exe' || l:jobinfocmd=~ 'powershell' || l:jobinfocmd=~ 'bash'
                  let l:target_tab_number = page_id
                  let l:term_win_id = 1      
                  let l:term_cmd = l:jobinfocmd
                  break
               endif
            endif
         endif 
       endfor

      " Create a terminal window in a new tabpage
      if l:target_tab_number == -1
         tab terminal ++close
         " Get the current terminal command
         let l:term_cmd = join(job_info(term_getjob(bufnr())).cmd, ' ')
      endif
   endif
   
   " Run Python code in the terminal window
   if l:term_cmd =~ 'cmd.exe'
      let l:usercmd = "\<CR> cls \<CR> py.exe"
   elseif l:term_cmd =~ 'powershell'
      let l:usercmd = "\<CR> clear \<CR> py.exe"
   else
      let l:usercmd = "\<CR> clear \<CR> py3"
   endif
   let l:cmd=l:usercmd.' '.l:filename."\<CR>"
   call term_sendkeys(bufnr(''), l:cmd)
   
   if a:runstyle == 0 
      " Switch back to the original window
      execute l:current_win_number . 'wincmd w'
   "else
      " Stay in terminal window and switch to Normal mode (not implemented)
      " execute 'wincmd N'
   endif
endfunction

"map: <F5>/<F8>
nnoremap <F5> :call RunPythonInTerminal(0)<CR>
nnoremap <F8> :call RunPythonInTerminal(1)<CR>

