" System gvimrc file for MacVim
"
" Maintainer:	Björn Winckler <bjorn.winckler@gmail.com>
" Last Change:	Sat Aug 11 2007
"
" This is a work in progress.  If you feel so inclined, please help me improve
" this file.


" Make sure the '<' and 'C' flags are not included in 'cpoptions', otherwise
" <CR> would not be recognized.  See ":help 'cpoptions'".
let s:cpo_save = &cpo
set cpo&vim


"
" Global default options
"

if !exists("syntax_on")
  syntax on
endif


"
" Extra menus
"


" File menu

aunmenu File.New
aunmenu File.Close
aunmenu File.-SEP4-
aunmenu File.Exit
aunmenu File.Save-Exit

an <silent> 10.290 File.New\ Window         :action newVimWindow:<CR>
an  10.295 File.New\ Tab                    :tabnew<CR>
an 10.328 File.-SEP0-                       <Nop>
an 10.330 File.Close<Tab>:q                 :confirm q<CR>
"an <silent> 10.330 File.Close\ Window       :confirm qa<CR>
"an 10.331 File.Close\ Tab                   :tabclose<CR>

an 20.460 Edit.-SEP4-                       <Nop>
an 20.465 Edit.Show\ Fonts\.\.\.            :action orderFrontFontPanel:<CR>
an 20.470 Edit.Special\ Characters\.\.\.    :action orderFrontCharacterPalette:<CR>


" Window menu
aunmenu Window

an <silent> 70.300 Window.Minimize          :action performMiniaturize:<CR>
an <silent> 70.310 Window.Zoom              :action performZoom:<CR>
an 70.320 Window.-SEP1-                     <Nop>
" TODO! Grey out if no tabs are visible.
an <silent> 70.330 Window.Previous\ Tab     :tabprevious<CR>
an <silent> 70.340 Window.Next\ Tab         :tabnext<CR>
an 70.350 Window.-SEP2-                     <Nop>
an <silent> 70.360 Window.Bring\ All\ To\ Front :action arrangeInFront:<CR>



"
" Toolbar
"
" These items are special ('*' means zero or more arbitrary characters):
"   -space*-        an empty space
"   -flexspace*-    a flexible space
"   -*-             a separator item

" Remove some items so that all items are visible at the default window size.
"aunmenu ToolBar.Undo
"aunmenu ToolBar.Redo
"aunmenu ToolBar.-sep2-
"aunmenu ToolBar.Cut
"aunmenu ToolBar.Copy
"aunmenu ToolBar.Paste
"aunmenu ToolBar.-sep3-
aunmenu ToolBar.Replace
aunmenu ToolBar.FindNext
aunmenu ToolBar.FindPrev
aunmenu ToolBar.-sep5-
aunmenu ToolBar.-sep6-
aunmenu ToolBar.RunCtags
aunmenu ToolBar.TagJump
"aunmenu ToolBar.-sep7-
aunmenu ToolBar.FindHelp

"an 1.295 ToolBar.-flexspace7-   <Nop>



"
" Keyboard mappings
"




"
" Menu key equivalents (these should always have the 'D' modifier set)
"

menukeyequiv File.New\ Window       <D-n>
menukeyequiv File.New\ Tab          <D-t>

menukeyequiv File.Open\.\.\.        <D-o>
menukeyequiv File.Open\ Tab\.\.\.   <D-T>
"menukeyequiv File.Close\ Window     <D-W>
"menukeyequiv File.Close\ Tab        <D-w>
menukeyequiv File.Close             <D-w>
menukeyequiv File.Save              <D-s>
menukeyequiv File.Save\ As\.\.\.    <D-S>
menukeyequiv File.Print             <D-p>

menukeyequiv Edit.Undo              <D-z>
menukeyequiv Edit.Redo              <D-Z>
menukeyequiv Edit.Cut               <D-x>
menukeyequiv Edit.Copy              <D-c>
menukeyequiv Edit.Paste             <D-v>
menukeyequiv Edit.Select\ All       <D-a>
menukeyequiv Edit.Special\ Characters\.\.\.    <D-M-t> 

menukeyequiv Tools.Make             <D-b>
menukeyequiv Tools.List\ Errors     <D-l>
menukeyequiv Tools.List\ Messages   <D-L>
menukeyequiv Tools.Next\ Error      <D-C-Right>
menukeyequiv Tools.Previous\ Error  <D-C-Left>
menukeyequiv Tools.Older\ List      <D-C-Up>
menukeyequiv Tools.Newer\ List      <D-C-Down>

menukeyequiv Window.Minimize        <D-m>
menukeyequiv Window.Previous\ Tab   <D-M-Left>
menukeyequiv Window.Next\ Tab       <D-M-Right>


" Restore the previous value of 'cpoptions'.
let &cpo = s:cpo_save
unlet s:cpo_save
