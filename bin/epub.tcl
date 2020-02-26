#!/usr/bin/env tclsh
 
package require textutil::expander

textutil::expander epub

epub lb "<?tcl"
epub rb "?>"

lassign $::argv tplfile

proc @ {text} {
    epub cappend "$text\n"
}

proc epub-pagelist {} {
    return [read_file vimhelp.list]
}

proc read_file {fpath} {
  set fp [open $fpath]
  set text [read $fp]
  close $fp
  return $text
}

proc write_file {fpath text} {
  set fp [open $fpath "w"]
  puts -nonewline $fp $text
  close $fp
  return
}

puts [epub expand [read_file $tplfile]]
