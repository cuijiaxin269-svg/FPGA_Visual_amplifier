source [file join [file dirname [info script]] load_helpers.tcl]
proc hword {index} {rd [expr {0x00ff2000+4*$index}]}
proc hwait {index expected timeout} {
 set deadline [expr {[clock milliseconds]+$timeout}]
 while {[hword $index]!=$expected} {
  if {[clock milliseconds]>$deadline} {error "HMI word $index expected $expected, observed [hword $index]"}
  after 50
 }
}
proc hnative {command} {
 same 0x00ff6300 0x48514d31
 set length [string length $command]
 if {$length<1 || $length>95 || ![string is ascii -strict $command]} {error "Invalid native probe command"}
 set prior [rd 0x00ff630c]
 if {[rd 0x00ff6308]!=$prior} {error "Another JTAG probe request is pending"}
 for {set i 0} {$i<$length} {incr i 4} {
  set value 0
  for {set j 0} {$j<4 && $i+$j<$length} {incr j} {
   scan [string index $command [expr {$i+$j}]] %c byte
   set value [expr {$value|($byte<<($j*8))}]
  }
  mwr [expr {0x00ff6318+$i}] $value
 }
 mwr 0x00ff6314 $length
 set sequence [expr {($prior+1)&0xffffffff}]
 mwr 0x00ff6308 $sequence
 set deadline [expr {[clock milliseconds]+15000}]
 while {[rd 0x00ff630c]!=$sequence} {
  if {[clock milliseconds]>$deadline} {error "Native probe TX timeout: $command"}
  after 10
 }
 same 0x00ff6310 1
 puts "HMI_NATIVE_TX $command";flush stdout
}
proc hnumber {property} {
 set before [hword 58]
 hnative "get $property"
 set deadline [expr {[clock milliseconds]+3000}]
 while {[hword 58]==$before} {
  if {[clock milliseconds]>$deadline} {error "No numeric screen response: $property"}
  after 30
 }
 set value [hword 57];puts "HMI_SCREEN_NUMBER $property=$value"
 return $value
}
proc hemit {command} {
 # One native instruction emits the entire CRLF command from the real screen.
 # Unlike direct mailbox injection, this exercises P4 TX, screen interpreter,
 # screen TX, P4 RX, UART interrupt and the production command parser.
 set hex {}
 foreach char [split "$command\r\n" {}] {scan $char %c byte;lappend hex [format %02X $byte]}
 set before [hword 26]
 hnative "printh [join $hex { }]"
 hwait 26 [expr {$before+1}] 5000
 puts "HMI_SCREEN_EMITTED $command"
}
proc htext {property} {
 set first [rd 0x00ff2108]
 hnative "get $property"
 set deadline [expr {[clock milliseconds]+3000}]
 while {1} {
  set last [rd 0x00ff2108]
  if {$last<$first || $last-$first>512} {error "Unexpected RX volume during text query"}
  set bytes "";set cached_address -1;set word 0
  for {set n $first} {$n<$last} {incr n} {
   set address [expr {0x00ff2110+($n&8191)}]
   set aligned [expr {$address&~3}]
   if {$aligned!=$cached_address} {set word [rd $aligned];set cached_address $aligned}
   append bytes [format %c [expr {($word>>(8*($address&3)))&255}]]
  }
  if {[regexp {\x70([^\xff]*)\xff\xff\xff} $bytes -> value]} {
   puts "HMI_SCREEN_TEXT $property=$value";return $value
  }
  if {[clock milliseconds]>$deadline} {error "No text screen response: $property"}
  after 30
 }
}
proc hchecked {index value label} {
 set actual [hword $index]
 if {$actual!=$value} {error "$label expected=$value actual=$actual"}
 puts "HMI_ASSERT $label=$actual"
}
proc hstandby {} {hemit STOP;hwait 19 5 20000;hchecked 14 0 stopped}
proc hstart {} {hemit START;hwait 19 4 30000;hwait 16 3 5000;hwait 18 3 5000}
proc halpha {value bits} {
 hnative "page0.alpha.val=$value";hnative "page0.hgain.val=$value"
 foreach preset {0 12 50} {hnative "page0.p$preset.val=[expr {$value==$preset}]"}
 hemit "ALPHA $value";hwait 17 3 10000;hchecked 9 $value alpha_actual
 same 0x43c0006c $bits
 if {[hnumber page0.alpha.val]!=$value} {error "Screen alpha mismatch"}
}
proc hexposure {value} {
 hnative "page0.exposure.val=$value";hnative "page0.hexp.val=$value"
 hemit "EXPOSURE $value";hwait 18 1 5000;hchecked 7 $value exposure_target
}
