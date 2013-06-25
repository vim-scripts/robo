*robo.txt*  Android plugin for Vim.
==============================================================================
RRRRRRRRRRRRRRRR         OOOOOOOO      BBBBBBBBBBBBBBBB         OOOOOOOO     
R:::::::::::::::R      OO::::::::OO    B:::::::::::::::B      OO::::::::OO   
R::::::RRRRRR::::R   OO::::::::::::OO  B:::::BBBBBB:::::B   OO::::::::::::OO 
RR:::::R     R::::R O:::::::OO:::::::O BB::::B     B:::::B O:::::::OO:::::::O
  R::::R     R::::R O::::::O  O::::::O   B:::B     B:::::B O::::::O  O::::::O
  R::::R     R::::R O:::::O    O:::::O   B:::B     B:::::B O:::::O    O:::::O
  R::::RRRRRR::::R  O:::::O    O:::::O   B:::BBBBBB:::::B  O:::::O    O:::::O
  R::::::::::::RR   O:::::O    O:::::O   B::::::::::::BB   O:::::O    O:::::O
  R::::RRRRRR::::R  O:::::O    O:::::O   B:::BBBBBB:::::B  O:::::O    O:::::O
  R::::R     R::::R O:::::O    O:::::O   B:::B     B:::::B O:::::O    O:::::O
  R::::R     R::::R O:::::O    O:::::O   B:::B     B:::::B O:::::O    O:::::O
  R::::R     R::::R O::::::O  O::::::O   B:::B     B:::::B O::::::O  O::::::O
RR:::::R     R::::R O:::::::OO:::::::O BB::::BBBBBB::::::B O:::::::OO:::::::O
R::::::R     R::::R  OO::::::::::::OO  B::::::::::::::::B   OO::::::::::::OO 
R::::::R     R::::R    OO::::::::OO    B:::::::::::::::B      OO::::::::OO   
RRRRRRRR     RRRRRR      OOOOOOOO      BBBBBBBBBBBBBBBB         OOOOOOOO     
==============================================================================

0.  |About| 

1.  |Initialization|
==============================================================================
    1.1      |Starting|
    1.2      |Exiting|

2.  |Commands|
==============================================================================
    2.1      |RoboInit|
    2.2      |RoboUnInit|
    2.3      |RoboOpenManifest|
    2.4      |RoboOpenActivity|
    2.6      |RoboGoToActivity|
    2.7      |RoboActivityExplorer|
    2.8      |RoboGoToResource|
    2.9      |RoboRunEmulator|
    2.10     |RoboAddActivity|
    2.11     |RoboInsertMissingImport|

3.  |Variables|
==============================================================================
    3.1     |g:RoboLoaded|
    3.2     |g:RoboManifestFile|
    3.3     |g:RoboActivityList|
    3.4     |g:RoboProjectDir|
    3.5     |g:RoboAntBuildFile|
    3.6     |g:RoboPackageName|
    3.7     |g:RoboSrcDir|
    3.8     |g:RoboResDir|
    3.9     |makeprg|
    3.10    |efm|

4. |Compiling|
5. |Mappings|

-----------------------------------------------------------------------------

0. *About*
Robo is a small set of tools for android developers that use ant. After
succesfully reading the Android.xml file it adds some
|Commands| and some |Shortcuts|.



1. *Initialization*
===============================================================================
                  
    1.1. *Starting*
    Robo has to be sarted manually. |RoboInit| command is used  to start Robo.

    1.2. *Exiting*
                 
    RoboUnInit can be used to deactivate the script. It removes all the
    commands except RoboInit.

2. *Commands*
===============================================================================

    2.1. *RoboInit*
                  
    Invoking this command will ask for the AndroidManifest.xml file. It
    will register all Robo commands and populate the global variables used by
    the plugin.

        |g:RoboLoaded|
        |g:RoboManifestFile|
        |g:RoboActivityList|
        |g:RoboProjectDir|
        |g:RoboAntBuildFile|
        |g:RoboPackageName|
        |g:RoboSrcDir|
        |g:RoboResDir|
        |makeprg|
        |efm|

    2.2. *RoboUnInit*

    Disables the plugin.

    2.3. *RoboOpenManifest*

    Opens the manifest file.

    2.4. *RoboOpenActivity*

    Opens the source file for the given activity name from Vim command line.

    2.5. *RoboGoToActivity*

    Goes to the source file for the activity name under the cursor. Works like
    'gf'.

    2.6. *RoboActivityExplorer*

    Shows a list of activities from the manifest. Pressing <CR> goes to the
    activity under the cursor.

    2.7. *RoboGoToResource*

    Goes to the xml resource file for  under the cursor. Works like 'gf'.

    2.8. *RoboGoRunEmulator*

    Shows a list of available virtual devices. Pressing <CR> starts the device
    under the cursor.

    2.9. *RoboAddActivity*

    Adds a source file for the name given as the input. The package name is
    grabbed from manifest and By default the new class will extend Activity.
    
    Here's what the file looks like:
>
    package erden.stagefast;

    import android.app.Activity;
    import android.os.Bundle;
    public class UploadActivity extends Activity {
        @Override
        public void onCreate(Bundle SavedInstanceState){
            super.onCreate(SavedInstanceState);
        }

    }
<    
    2.9. *RoboInsertMissingImport*
   
    Tries to add the missing import using the 'classes' file generated during
    init. This command must be run while cursor is on the item that needs to
    be imported.

3. *Variables* 
===============================================================================
    3.1. *g:RoboLoaded*
                                                   
    If plugin is active this variable is 1. 

    3.2. *g:RoboManifestFile*

    A string that holds the full path to the AndroidManifest.xml file ie:
    '/home/timmayy/android/fasterTeleport/AndroidManifest.xml'

    3.3. *g:RoboActivityList*

    A list holding the activities found in the manifest file.
    
    3.4. *g:RoboProjectDir*

    A string holding the name of the project directory. This is where the
    manifest file is.

    3.5. *g:RoboAntBuildFile*

    A string holding the full path to the build.xml file.

    3.6. *g:RoboPackageName*

    A string holding the package name declared in the manifest file.

    3.7. *g:RoboSrcDir*
    
    A string holding the path to directory to the source files. It assumes
    source files are in:
        
        g:RoboProjectDir/src/your/package/name/

    3.8. *g:RoboResDir*
    
    A string holding the path to directory to the resource files. It assumes
    resource files are in:
        
        g:RoboProjectDir/res/

    3.9. *makeprg*

    Make program is set to:

        'ant -emacs -buildfile' . g:RoboAntBuildFile

    See: |Compiling|.

    3.10. *efm*

    Error format is set to:

        '%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#'

4. *Compiling*    
===============================================================================
    Since 'makepgrg' is set to ant, these should work as expected:
>
    :make debug install 
    :make debug
    :make installd
<

All available ant targets should work.

5. *Mappings*
   These are the mappings that are available after the init.

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


vim:tw=78:ts=8:ft=help:norl:iskeyword+=\:
