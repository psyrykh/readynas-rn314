project( 'rn314', 'C', version : '1.0.0' )

uname = run_command( 'uname', '-r', check: true ).stdout().strip()
uname_without_arch =  run_command(  'sh',
                                '-c',
                                'uname -r | sed \'s/-/ /g\' | awk \'{ print $1 "-" $2 }\'',
                                check: true ).stdout().strip()

kernel_dir = '/lib/modules/' + uname + '/build'

rn314_src = []
rn314_src += 'src/module.c'
rn314_src += 'src/lcd.c'
rn314_src += 'src/led.c'
rn314_src += 'src/buttons.c'



##########################################################################
# Fake target to allow qtcreator editing without a scaring syntax analyser
rn314_includes = []
rn314_includes += '/usr/lib/gcc/x86_64-linux-gnu/10/include'
rn314_includes += '/usr/src/linux-headers-' + uname + '/include'
rn314_includes += '/usr/src/linux-headers-' + uname + '/arch/x86/include/generated'
rn314_includes += '/usr/src/linux-headers-' + uname + '/arch/x86/include/generated/uapi'
rn314_includes += '/usr/src/linux-headers-' + uname + '/include/generated/uapi'

rn314_includes += '/usr/src/linux-headers-' + uname_without_arch + '-common/include'
rn314_includes += '/usr/src/linux-headers-' + uname_without_arch + '-common/arch/x86/include'
rn314_includes += '/usr/src/linux-headers-' + uname_without_arch + '-common/arch/x86/include/uapi'
rn314_includes += '/usr/src/linux-headers-' + uname_without_arch + '-common/include/uapi'


add_project_arguments( '-D__KERNEL__', language : 'C' )
add_project_arguments( '-DCONFIG_X86_X32_ABI', language : 'C' )
add_project_arguments( '-DCC_USING_FENTRY', language : 'C' )
add_project_arguments( '-DMODULE', language : 'C' )
add_project_arguments( '-DKBUILD_BASENAME="rn314"', language : 'C' )
add_project_arguments( '-DKBUILD_MODNAME="rn314"', language : 'C' )
add_project_arguments( '-Wno-pointer-sign', language : 'C' )

if get_option( 'qtcreator' )
  rn314 = shared_library('rn314',
                          rn314_src,
                          include_directories : rn314_includes,
                          build_by_default: false )
endif


##########################################################################
# Real target
custom_target( 'rn314_module_build',
            input : rn314_src,
            output : 'rn314.ko',
            command: [ 'make',
                        '-j', '4',
                        '-C', kernel_dir,
                        'M='+ meson.current_build_dir(),
                        'src=' + meson.current_source_dir() + '/src',
                        'clean',  'modules' ],
            console: true,
            install: false,
            build_by_default: true )

