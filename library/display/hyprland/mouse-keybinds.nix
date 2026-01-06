{ pkgs, ... }:
let
  super = "SUPER";
  alt = "ALT";
  shift = "SHIFT";
  ctrl = "CTRL";

in
[
  # Mouse Control
  "${alt} ${ctrl}, mouse:272, movewindow"
  "${alt} ${ctrl}, mouse:273, resizewindow"
]
