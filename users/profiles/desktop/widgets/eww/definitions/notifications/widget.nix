{ lib, pkgs, ... }:


{
  def = ''
    <revealer transition="slidedown" duration="500ms" reveal="{{notificationsList}}">
        <notifications-right/>
      </revealer>
  '';
}
