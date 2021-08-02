{ lib, pkgs, ... }:


{
  def = ''
    <revealer transition="slidedown" duration="500ms" reveal="{{notificationBool}}">
        <notifications-center/>
      </revealer>
  '';
}
