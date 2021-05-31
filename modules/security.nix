{ config, lib, pkgs, ... }:

{
  ## System security tweaks
  # sets hidepid=2 on /proc (make process info visible only to owning user)
  # NOTE Was removed on nixpkgs-unstable because it doesn't do anything
  # security.hideProcessInformation = true;
  # Prevent replacing the running kernel w/o reboot
  security.protectKernelImage = true;

  # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
  # on ssd systems, and volatile! Because it's wiped on reboot.
  boot.tmpOnTmpfs = lib.mkDefault true;
  # If not using tmpfs, which is naturally purged on reboot, we must clean it
  # /tmp ourselves. /tmp should be volatile storage!
  boot.cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);

  # Fix a security hole in place for backwards compatibility. See desc in
  # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
  boot.loader.systemd-boot.editor = false;

  boot.kernel.sysctl = {
    # The swappiness sysctl parameter represents the kernel's preference (or avoidance) of swap space. Swappiness can have a value between 0 and 100, the default value is 60. 
    # A low value causes the kernel to avoid swapping, a higher value causes the kernel to try to use swap space. Using a low value on sufficient memory is known to improve responsiveness on many systems.
      "vm.swappiness" = 10;

      # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache). 
      # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
      "vm.vfs_cache_pressure" = 50;

      # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
      # Disable NMI watchdog
      #"kernel.nmi_watchdog" = 0;

      # Contains, as a percentage of total available memory that contains free pages and reclaimable
      # pages, the number of pages at which a process which is generating disk writes will itself start
      # writing out dirty data (Default is 20).
      "vm.dirty_ratio" = 5;

      # Contains, as a percentage of total available memory that contains free pages and reclaimable
      # pages, the number of pages at which the background kernel flusher threads will start writing out
      # dirty data (Default is 10).
      "vm.dirty_background_ratio" = 5;

      # This tunable is used to define when dirty data is old enough to be eligible for writeout by the
      # kernel flusher threads.  It is expressed in 100'ths of a second.  Data which has been dirty
      # in-memory for longer than this interval will be written out next time a flusher thread wakes up
      # (Default is 3000).
      #vm.dirty_expire_centisecs = 3000

      # The kernel flusher threads will periodically wake up and write old data out to disk.  This
      # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
     "vm.dirty_writeback_centisecs" = "1500";

     # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
    "kernel.unprivileged_userns_clone" = 1;

    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

    ## TCP hardening
    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Don't send ICMP redirects (again, we're on a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;
    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    ## TCP optimization
    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;
    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
  };
  boot.kernelModules = [ "tcp_bbr" ];

  # Change me later!
  users.users.root.initialPassword = "nixos";

  # So we don't have to do this later...
  security = {
    acme.acceptTerms = true;
    sudo = {
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
        # For profile-sync-daemon with overlaysfs
	user ALL=(ALL) NOPASSWD: ${pkgs.profile-sync-daemon}/bin/psd-overlay-helper
      '';
      wheelNeedsPassword = false;
    };
  };
}