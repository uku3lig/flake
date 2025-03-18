#!/bin/bash
# https://www.opendesktop.org/p/999853

COPY="cp"
#COPY="ln -s"


function copy
{
	missing="$1"
	shift
	for cursor2 in "$@"; do
		if [ -e "$cursor2" ]; then
			$COPY "$cursor2" "$missing"
			return
		fi
	done
}

function add
{
	echo ""
	for array in "$@"; do
		array=( $array )
		for cursor in "${array[@]}"; do
			echo -n "Checking $cursor ... "
			if [ -e "$cursor" ]; then
				echo "OK"
				continue
			fi
			if [ ! -e "$cursor" ]; then
				copy "$cursor" ${array[@]}
			fi
			if [ ! -e "$cursor" ]; then
				copy "$cursor" $@
			fi
			if [ -e "$cursor" ]; then
				echo "COPIED"
			else
				echo "MISSING!"
			fi
		done
		echo ""
	done
}


# cursors

       default=( "default"        "left_ptr"                         "top_left_arrow"                   "left-arrow"                                                                                                                                )
                                                                                                                                                                                                  
         arrow=( "arrow"          "right_ptr"                        "top_right_arrow"                  "right-arrow"                                                                                                                               )
                                                                                                                                                                                                  
    center_ptr=( "center_ptr"                                                                                                                                                                                                                       )
                                                                                                                                                                                                  
          link=( "link"           "alias"                            "0876e1c15ff2fc01f906f1c363074c0f" "3085a0e285430894940527032f8b26df" "640fb0e74195791501fd1ed57b41487f" "a2a266d0498c3104214a47bd64ab0fc8"                                    )
      dnd_link=( "dnd-link"                                                                                                                                                                                                                         )
                                                                                                                                                                                                  
     forbidden=( "forbidden"      "not-allowed"                                                                                                                                                                                                     )
crossed_circle=( "crossed_circle" "03b6e0fcb3499374a867c041f52298f0"                                                                                                                                                                                )
        circle=( "circle"                                                                                                                                                                                                                           )
   dnd_no_drop=( "dnd-no-drop"    "no-drop"                          "03b6e0fcb3499374a867c041f52298f0" "03b6e0fcb3499374a867d041f52298f0"                                                                                                          )
                                                                                                                                                                                                  
        pirate=( "pirate"         "kill"                                                                                                                                                                                                            )
                                                                                                                                                                                                  
        pencil=( "pencil"                                                                                                                                                                                                                           )
                                                                                                                                                                                                  
          wait=( "wait"           "watch"                            "clock"                            "0426c94ea35c87780ff01dc239897213"                                                                                                          )
                                                                                                                                                                                                  
     half_busy=( "half-busy"      "progress"                         "left_ptr_watch"                   "00000000000000020006000e7e9ffc3f" "08e8e1c95fe2fc01f976f1e063a24ccd" "3ecb610c1bf2410f44200f48c40d3599" "9116a3ea924ed2162ecab71ba103b17f" )
                                                                                                                                                                                                  
          help=( "help"           "question_arrow"                   "whats_this"                       "gumby"                            "5c6cd98b3f3ebcb1f9c7f1c204630408" "d9ce0ab605698f320427677b458ad60b"                                    )
       dnd_ask=( "dnd-ask"                                                                                                                                                                                                                          )
                                                                                                                                                                                                  
     ns_resize=( "ns-resize"      "size_ver"                         "v_double_arrow"                   "double_arrow"                     "00008160000006810000408080010102"                                                                       )
      n_resize=( "n-resize"       "top_side"                                                                                                                                                                                                        )
      s_resize=( "s-resize"       "bottom_side"                                                                                                                                                                                                     )
                                                                                                                                                                                                  
     ew_resize=( "ew-resize"      "size_hor"                         "h_double_arrow"                   "028006030e0e7ebffc7f7070c0600140"                                                                                                          )
      e_resize=( "e-resize"       "right_side"                                                                                                                                                                                                      )
      w_resize=( "w-resize"       "left_side"                                                                                                                                                                                                       )
                                                                                                                                                                                                  
     nw_resize=( "nw-resize"      "top_left_corner"                                                                                                                                                                                                 )
     se_resize=( "se-resize"      "bottom_right_corner"                                                                                                                                                                                             )
    size_fdiag=( "size_fdiag"     "nwse-resize"                      "38c5dff7c7b8962045400281044508d2" "c7088f0f3e6c8088236ef8e1e3e70000"                                                                                                          )
                                                                                                                                                                                                  
     ne_resize=( "ne-resize"      "top_right_corner"                                                                                                                                                                                                )
     sw_resize=( "sw-resize"      "bottom_left_corner"                                                                                                                                                                                              )
    size_bdiag=( "size_bdiag"     "nesw-resize"                      "50585d75b494802d0151028115016902" "fcf1c3c7cd4491d801f1e1c78f100000"                                                                                                          )
                                                                                                                                                                                                  
      size_all=( "size_all"                                                                                                                                                                                                                         )
                                                                                                                                                                                                  
          move=( "move"           "fleur"                            "4498f0e0c1937ffe01fd06f973665830" "9081237383d90e509aa00f00170e968f" "fcf21c00b30f7e3f83fe0dfd12e71cff"                                                                       )
      dnd_move=( "dnd-move"                                                                                                                                                                                                                         )
    all_scroll=( "all-scroll"                                                                                                                                                                                                                       )

    closedhand=( "closedhand"     "grabbing"                         "208530c400c041818281048008011002"                                                                                                                                             )
      dnd_none=( "dnd-none"                                                                                                                                                                                                                         )
                                                                                                                                                                                                  
      openhand=( "openhand"       "5aca4d189052212118709018842178c0" "9d800788f1b08800ae810202380a0822"                                                                                                                                             )
                                                                                                                                                                                                  
      up_arrow=( "up_arrow"                                                                                                                                                                                                                         )
                                                                                                                                                                                                  
  color_picker=( "color-picker"                                                                                                                                                                                                                     )
                                                                                                                                                                                                  
          text=( "text"           "ibeam"                            "xterm"                                                                                                                                                                        )
                                                                                                                                                                                                  
 vertical_text=( "vertical-text"  "048008013003cff3c00c801001200000"                                                                                                                                                                                )
                                                                                                                                                                                                  
     crosshair=( "crosshair"                                                                                                                                                                                                                        )
                                                                                                                                                                                                  
          copy=( "copy"           "08ffe1cb5fe6fc01f906f1c063814ccf" "1081e37283d90000800003c07f3ef6bf" "6407b0e94181790501fd1e167b474872" "b66166c04f8c3109214a4fbd64a50fc8"                                                                       )
      dnd_copy=( "dnd-copy"                                                                                                                                                                                                                         )
                                                                                                                                                                                                  
       pointer=( "pointer"        "pointing_hand"                    "hand1"                            "e29285e634086352946a0e7090d73106"                                                                                                          )
         hand2=( "hand2"                                                                                                                                                                                                                            )
                                                                                                                                                                                                  
         cross=( "cross"          "diamond_cross"                    "target"                                                                                                                                                                       )
          cell=( "cell"                                                                                                                                                                                                                             )
                                                                                                                                                                                                  
    col_resize=( "col-resize"     "sb_h_double_arrow"                "043a9f68147c53184671403ffa811cc5" "14fef782d02440884392942c11205230"                                                                                                          )
       split_h=( "split_h"                                                                                                                                                                                                                          )
                                                                                                                                                                                                  
    row_resize=( "row-resize"     "sb_v_double_arrow"                "2870a09082c103050810ffdffffe0204" "c07385c7190e701020ff7ffffd08103c"                                                                                                          )
       split_v=( "split_v"                                                                                                                                                                                                                          )
                                                                                                                                                                                                  
          plus=( "plus"                                                                                                                                                                                                                             )
                                                                                                                                                                                                  
      X_cursor=( "X_cursor"       "X-cursor"                                                                                                                                                                                                        )
                                                                                                                                                                                                  
  context_menu=( "context-menu"   "08ffe1e65f80fcfdf9fff11263e74c48"                                                                                                                                                                                )
                                                                                                                                                                                                  
          zoom=( "zoom"                                                                                                                                                                                                                             )
      zoom_out=( "zoom-out"       "zoom_out"                         "f41c0e382c97c0938e07017e42800402"                                                                                                                                             )
       zoom_in=( "zoom-in"        "zoom_in"                          "f41c0e382c94c0958e07017e42b00462"                                                                                                                                             )


# adding

add "`echo ${default[@]}`"
 
add "`echo ${arrow[@]}`"
 
add "`echo ${center_ptr[@]}`"
 
add "`echo ${link[@]}`" "`echo ${dnd_link[@]}`"
 
add "`echo ${forbidden[@]}`" "`echo ${crossed_circle[@]}`" "`echo ${circle[@]}`" "`echo ${dnd_no_drop[@]}`"
 
add "`echo ${pirate[@]}`"
 
add "`echo ${pencil[@]}`"
 
add "`echo ${wait[@]}`"
 
add "`echo ${half_busy[@]}`"
 
add "`echo ${help[@]}`" "`echo ${dnd_ask[@]}`"
 
add "`echo ${ns_resize[@]}`" "`echo ${n_resize[@]}`" "`echo ${s_resize[@]}`"
 
add "`echo ${ew_resize[@]}`" "`echo ${e_resize[@]}`" "`echo ${w_resize[@]}`"
 
add "`echo ${nw_resize[@]}`" "`echo ${se_resize[@]}`" "`echo ${size_fdiag[@]}`"
 
add "`echo ${ne_resize[@]}`" "`echo ${sw_resize[@]}`" "`echo ${size_bdiag[@]}`"
 
add "`echo ${size_all[@]}`"
 
add "`echo ${move[@]}`" "`echo ${dnd_move[@]}`" "`echo ${all_scroll[@]}`"

add "`echo ${closedhand[@]}`" "`echo ${dnd_none[@]}`"
 
add "`echo ${openhand[@]}`"
 
add "`echo ${up_arrow[@]}`"
 
add "`echo ${color_picker[@]}`"
 
add "`echo ${text[@]}`"
 
add "`echo ${vertical_text[@]}`"
 
add "`echo ${crosshair[@]}`"
 
add "`echo ${copy[@]}`" "`echo ${dnd_copy[@]}`"
 
add "`echo ${pointer[@]}`" "`echo ${hand2[@]}`"
 
add "`echo ${cross[@]}`" "`echo ${cell[@]}`"
 
add "`echo ${col_resize[@]}`" "`echo ${split_h[@]}`"
 
add "`echo ${row_resize[@]}`" "`echo ${split_v[@]}`"
 
add "`echo ${plus[@]}`"
 
add "`echo ${X_cursor[@]}`"
 
add "`echo ${context_menu[@]}`"
 
add "`echo ${zoom[@]}`" "`echo ${zoom_out[@]}`" "`echo ${zoom_in[@]}`"


# done

exit 0
