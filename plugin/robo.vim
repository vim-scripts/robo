"This program is free software: you can redistribute it and/or modify
"it under the terms of the GNU General Public License as published by
"the Free Software Foundation, either version 3 of the License, or
"(at your option) any later version.

"This program is distributed in the hope that it will be useful,
"but WITHOUT ANY WARRANTY; without even the implied warranty of
"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"GNU General Public License for more details.

"You should have received a copy of the GNU General Public License
"along with this program.  If not, see <http://www.gnu.org/licenses/>.
"===============================================================================
"Ercan Erden - 2012
"ercerden@gmail.com
"http://www.bitbucket.org/ercax
"===============================================================================

"--------- Robo ----------
"An Android plugin for Vim.

function! s:GotoActivity()"{{{
    if g:RoboLoaded == 0
        echoerr "Robo not loaded!"
        return
    endif
    let currentWord =  expand('<cword>')
    let activity = substitute(currentWord, '^\.', '','')
    call s:OpenActivity(activity)
endfunction"}}}

function! s:GetMinSdk(manifest)"{{{
    let targetSdk = []
    let manifestFile = readfile(a:manifest)
    for line in manifestFile
        "let targetSdk = matchlist(line, 'android:minSdkVersion.\{-}=.\{-}["\']\([0-9]\).\{-}["\']'
        let targetSdk = matchlist(line, 'minSdkVersion.\{-}\(\d\{1,3}\)')
        if len(targetSdk) > 0
            return targetSdk[1]
        endif
    endfor
    echoerr "Can't get min SDK, do you have 'android:minSdkVersion' in your manifest file?"
endfunction"}}}

function! s:GetActivityList(manifest)"{{{
    let manifestfile = readfile(a:manifest)
    let activityFront = '' 
    let activityMiddle = ''
    let activityBack = '' 
    let activityStringList = []
    let intag = 0
    let activitylist = []
    for line in manifestfile
        "Get rid of unncecessary spaces.
        "Useful when debugging.
        let line = substitute(line, '\s\+',' ','')

        let activityFront =  matchstr(line, "<activity")
        let activityBack =  matchstr(line, "</activity>")
        if len(activityFront) > 0
            let intag = 1
        endif
        if (intag) 
            let activityMiddle = activityMiddle . line
        endif

        if len(activityBack) > 0
            let intag = 0
            let activityStringList += [activityMiddle]
            let activityMiddle = ''
        endif
    endfor
    for line in activityStringList
        let currentActivity = matchlist(line, '<activity\_.\{-}android:name="\(.\{-}\)".\{-}>')
        let activity = currentActivity[1]
        let activitylist += [substitute(activity, '^\.', '','')]
    endfor
    return activitylist
endfunction"}}}

function! s:GetActivities(manifest)"{{{
    let activities = []
    let manifestfile = readfile(a:manifest)
    for line in manifestfile
        let activitylistItem =  matchlist(line, '<activity\_.\{-}android:name="\(.\{-}\)"')
        if len(activitylistItem) > 0
            let activityName = activitylistItem[1]
            echo activityName
            let activities += [activityName]
        endif
    endfor
    return activities
endfunction"}}}

function! s:SetManifestFile()"{{{
    let manifest =  input("Manifest Location: ", "", "file")
    if(len(manifest) != 0)
        return manifest
    else
        echoerr "empty string"
        return null
    endif
endfunction"}}}

function! s:GetDirectories(manifest)"{{{
  let pathlen =  match(a:manifest, 'AndroidManifest.xml')  
  return strpart(a:manifest, 0, pathlen)
endfunction"}}}

function! s:OpenManifestFile()"{{{
    exec 'edit ' .  g:RoboManifestFile
endfunction"}}}

function! s:GetPackagePath(packageName)"{{{
    return substitute(a:packageName,'\.','/', 'g').'/'
endfunction"}}}

function! s:GetPackageName(manifest)"{{{
    let manifestfile = readfile(a:manifest)
    for line in manifestfile
        let packagename = matchlist(line,'package="\(.\{-}\)"' )
        if len(packagename) > 0
            return packagename[1]
        endif
    endfor
endfunction"}}}

function! s:GetSrcDir()"{{{
   return g:RoboProjectDir . 'src/' . s:RoboPackagePath 
endfunction"}}}

function! s:OpenActivity(name)"{{{

    let filename =  g:RoboSrcDir. a:name . '.java'
    if filereadable(filename)
        exec 'edit ' .  filename
    else
        echohl WarningMsg |echo "No file!" | echohl Normal
    endif
endfunction"}}}

function! s:ListActivities(A,L,P)"{{{
    return filter(g:RoboActivityList, 'v:val =~? "' . a:A . '"')
endfunction"}}}

function! s:ShowActivities()"{{{
    exec 'enew'
    "call append(0,"  Select activity (<Enter> : open) | s : sorting (manifest)")
    call append(0,"  Select activity (<Enter> : open)")
    call append(1,'-----------------------------------')
    for i in range(0, len(g:RoboActivityList) - 1)
        call append(i+2, "    " . g:RoboActivityList[i])
    endfor
    setlocal buftype=nofile
    setlocal buftype=nowrite
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal nospell
    setlocal foldcolumn=0
    setlocal nomodifiable
    setlocal nonumber
    map <buffer> <cr> :RoboGoToActivity<cr>
    map <buffer> o :RoboGoToActivity<cr>
endfunction"}}}

function! s:FindRes()"{{{
    "echo matchlist(line, 'R\..\{-}\..\{-}\>')
    let word = expand('<cWORD>')
    let results =  matchlist(word, 'R\.\([a-z0-9]*\)\.\([a-z0-9_]*\)')
    if len(results) == 0
        return
    endif
    if results[1] == 'id'
        echo 'This is not happening.'
    else
        let path =  g:RoboProjectDir . 'res/' . results[1] . '/' .results[2] . '.xml'
        exec 'edit ' .path
    endif
    
endfunction"}}}

function! s:ShowEmulators()"{{{
    let avdList = []
    let avd = []
    let avdDict = {}
    exec 'enew'
    "let avds = split(system('android list avd|grep -i name'),'\n')
    let cmdResult = system('android list avd')
    call setline(1, 'List of available virtual devices:')
    call setline(2, '--------------------------------------------------------------------------------')
    let avdLines = split(cmdResult, '---------')
    for line in avdLines
        let avd= matchlist(line, 'Name: \(.\{-}\)\n\_.\{-}Target: \(.\{-}\)\n')
        let avdList += [avd]
    endfor
    for avd in avdList
        call append(2,'Name: '. avd[1]. "\t| Target: " . avd[2]) 
    endfor

    setlocal tabstop=9
    setlocal buftype=nofile
    setlocal buftype=nowrite
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal nospell
    setlocal foldcolumn=0
    setlocal nomodifiable
    setlocal nonumber
    map <buffer> <silent> <cr> :call <SID>RunEmulator()<cr>

endfunction"}}}

function! s:RunEmulator()"{{{
    let line = getline(".")    
    let match = matchlist(line, '^Name: \(.\{-}\)\s') 
    let commandString = 'emulator @' . match[1] . " &"
    let err = system('emulator @' . match[1] . " &")
    if err != ''
        echo err
    endif
endfunction"}}}

function! s:UnInit()"{{{
    unlet g:RoboLoaded
    unlet g:RoboManifestFile
    unlet g:RoboActivityList
    unlet g:RoboProjectDir
    unlet s:RoboPackagePath
    unlet g:RoboSrcDir
    unlet g:RoboResDir

    "Set up vim stuff"
    "Commands
    delcommand RoboOpenManifest
    delcommand RoboOpenActivity
    delcommand RoboGoToActivity
    delcommand RoboUnInit
    delcommand RoboRunEmulator

    "Statusline
    set statusline-=%=[Robo]

endfunction"}}}

function! s:AddActivity()"{{{
    let activityName =  input("Activity name: ")
    call s:AddActivityToManifest(activityName)
    call s:AddActivityFile(activityName)
    "Update the list so the new activity is available.
    let g:RoboActivityList = s:GetActivityList(g:RoboManifestFile) 
endfunction"}}}

function! s:AddActivityFile(activityName)"{{{
    let activityFileName  = a:activityName . '.java'
    let template = []
    let template += ['package ' . g:RoboPackageName .';']
    let template += ['']
    let template += ['import android.app.Activity;']
    let template += ['import android.os.Bundle;']
    let template += ['public class '. a:activityName .' extends Activity {']
    let template += ['@Override']
    let template += ['public void onCreate(Bundle SavedInstanceState){']
    let template += ['super.onCreate(SavedInstanceState);']
    let template += ['}']
    let template += ['']
    let template += ['}']
    "exec 'e ' . g:RoboSrcDir . activityName . '.java'
    let filePath = g:RoboSrcDir . activityFileName
    call writefile(template, filePath)
    exec 'e '.filePath
    exec 'normal gg=G'
    exec 'w'

endfunction"}}}

function! s:AddActivityToManifest(activityName)"{{{
    let manifest = readfile(g:RoboManifestFile)
    let index = match(manifest, '\/application>')
    call insert(manifest, '<activity android:name=".' . a:activityName . '"></activity>', index)
    if filewritable(g:RoboManifestFile) > 0
        call writefile(manifest, g:RoboManifestFile)
    endif
    exec 'e ' . g:RoboManifestFile
    exec 'normal gg=G'
    exec 'w'
endfunc"}}}

function! s:FindImport()"{{{
    "Todo: Have to create this file manually, find a solution.
    let importList = readfile(g:RoboProjectDir . 'classes')
    let name = expand('<cword>')
    let result = []
    for line in importList
        let match =  matchlist(line, '.*\.\(' . name . '\)$')
        if len(match) > 0
            let result += [match[0]]
        endif
    endfor

    "There's no result, return empty list.
    if len(result) < 1
        return result
    endif

    "There's only one result, return it.
    if len(result) < 2
        return result[0]
    endif

    "More than one match, let the user select.
    if len(result) > 1
        let index = 0
        echo "Select import statement (<Ctrl-c> to cancel)"
        echo "-----------------------"
        for line in result
            echo index . " : " line
            let index += 1
        endfor
        echo "-----------------------"
        let input = input("Enter number:")
        return result[input]
    endif
endfunction"}}}

function! s:InsertMissingImport()"{{{
    let missingImport = s:FindImport()

    if len(missingImport) < 1
        echo "Can't find anything to import."
        return
    endif
    if search('import.\{-}' . missingImport) > 0 
        echo "Import already exists."
        return
    endif
    call append(2,'import ' . missingImport . ';')
endfunction"}}}

function! s:CreateClassIndex()"{{{
    "Get the lines that end with '.class' from android.jar file.
    let commandString = 'jar -tf ' . $ANDROID_HOME . '/platforms/android-'. g:RoboMinSdkVersion .'/android.jar | grep \.class$ > '. g:RoboProjectDir .'classes_unfiltered'
    let error_msg = system(commandString)
    if v:shell_error > 0
        echo "\n"
        echo "\n"
        echo "There was an error while running this command: " . commandString
        echo "\n"
        echo "Here's the output from the command:\n\n"
        echo error_msg
        echo "\n"
        echo "Check if the jar file exists in the given path. It might mean a typo in your minsdk value."
        echo "\n"
        return
    endif


    "Get rid of $ signs in class names.
    call system('sed s/\[\$\/]/\./g ' . g:RoboProjectDir . 'classes_unfiltered > classes_with_extension') 
    if v:shell_error > 0
        echoerr 'Error in sed command'
        return
    endif

    "Remove '.class' extension from lines.
    call system('sed s/.class$//g ' . g:RoboProjectDir . 'classes_with_extension > classes') 
    if v:shell_error > 0
        echoerr 'Error in sed command'
        return
    endif

    "Delete classes_unfiltered.
    call system('rm ' . g:RoboProjectDir . 'classes_unfiltered')
    if v:shell_error > 0
        echoerr 'Could not delete file: "classes_unfiltered" from the project folder. Delete it manually.'
    endif

    "Delete classes_with_extension.
    call system('rm ' . g:RoboProjectDir . 'classes_with_extension')
    if v:shell_error > 0
        echoerr 'Could not delete file: "classes_with_extension" from the project folder. Delete it manually.'
    endif


endfunction"}}}

function! s:Init()"{{{
    "Set globals. Any error here should cancel everything.
    let g:RoboLoaded = 1

    try
        let g:RoboManifestFile = s:SetManifestFile()  
    catch
        echoerr "Can't get manifest file."
        return
    endtry

    try
        let g:RoboActivityList = s:GetActivityList(g:RoboManifestFile) 
    catch
        echoerr "Can't get activity list."
        return
    endtry

    try
        let g:RoboProjectDir = s:GetDirectories(g:RoboManifestFile)
    catch
        echoerr "Can't get the project directory."
        return
    endtry

    try
        let g:RoboPackageName = s:GetPackageName(g:RoboManifestFile)
    catch
        echoerr "Can't get packagename from manifest."
        return
    endtry

    try
        let s:RoboPackagePath = s:GetPackagePath(g:RoboPackageName)
    catch
        echoerr "Can't get package path."
        return
    endtry

    try
        let g:RoboSrcDir = s:GetSrcDir()
    catch
        echoerr "Cant get the source directory."
        return
    endtry

    let g:RoboResDir = g:RoboProjectDir . 'res/' 
    try
        let g:RoboMinSdkVersion = s:GetMinSdk(g:RoboManifestFile)
    catch
        echoerr "Can't get MinSdk. Add it to the manifest."
    endtry

    "Create the classes file and add it's full path to g:RoboClassesFile.
    call s:CreateClassIndex()

    "Set some variables
    let g:RoboClassesFile = g:RoboProjectDir . 'classes'
    let g:RoboAntBuildFile =  g:RoboProjectDir . 'build.xml'
    let &makeprg="ant -emacs -buildfile " . g:RoboAntBuildFile
    set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

    "Set commands
    command! -n=0 -bar RoboOpenManifest :call s:OpenManifestFile()
    command! -n=1 -complete=customlist,s:ListActivities -bar RoboOpenActivity :call s:OpenActivity('<args>')
    command! -n=0 -bar RoboGoToActivity :call s:GotoActivity()
    command! -n=0 -bar RoboUnInit :call s:UnInit()
    command! -n=0 -bar RoboActivityExplorer :call s:ShowActivities()
    command! -n=0 -bar RoboGoToResource :call s:FindRes()
    command! -n=0 -bar RoboRunEmulator :call <SID>ShowEmulators()
    command! -n=0 -bar RoboAddActivity :call <SID>AddActivity()
    command! -n=0 -bar RoboInsertMissingImport :call <SID>InsertMissingImport()

    "Set mappings
    nnoremap <Leader>rae :RoboActivityExplorer<cr>
    nnoremap <Leader>rom :RoboOpenManifest<cr>
    nnoremap <Leader>rga :RoboGoToActivity<cr>
    nnoremap <Leader>rgr :RoboGoToResource<cr>
    nnoremap <Leader>rre :RoboRunEmulator<cr>

    nnoremap <Leader>rdi :make debug install<cr>
    nnoremap <Leader>rdb :make debug<cr>
    nnoremap <Leader>rri :make release install<cr>
    nnoremap <Leader>rrb :make release<cr>

    nnoremap <Leader>rcl :make clean<cr>
    nnoremap <Leader>rui :make uninstall<cr>

endfunction"}}}

"Set up vim stuff"
command! -n=0 -bar RoboInit :call s:Init()
 "}}}
