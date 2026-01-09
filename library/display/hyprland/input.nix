# https://wiki.hypr.land/Configuring/Variables/#input
{
  input = {
    kb_layout = "us";
    follow_mouse = 1;
    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    accel_profile = "flat";

    repeat_rate = 50;
    repeat_delay = 300;

    touchpad = {
      natural_scroll = true;
      "tap-to-click" = true;
      drag_lock = true;
    };
  };

  # https://wiki.hypr.land/Configuring/Gestures/
  gesture = [
    "3, horizontal, workspace"
  ];
}
