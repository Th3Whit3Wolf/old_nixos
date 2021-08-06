{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  # Use the latest kernel
  boot = {
    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      availableKernelModules = [
        "aesni_intel"
        "cryptd"
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      luks.devices."crypt".device =
        "/dev/disk/by-uuid/57d2784d-0fcb-471b-838f-cbcca73fda93";
      kernelModules = [ ];
    };
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      /*
        * Hardened
      */

      # Slab/slub sanity checks, redzoning, and poisoning
      "slub_debug=FZP"

      # Overwrite free'd memory
      "page_poison=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"

      /*
        * Silent Boot
      */

      # Prevents unneccesary infor being written to stdout durring boot.
      "quiet"
      "udev.log_priority=3"

      /*
        * Laptop Quirks
      */
      "add_efi_memmap"
      "acpi_backlight=native"
    ];
    kernelModules = [ "kvm-amd" "tcp_bbr" ];

    kernel.sysctl = {
      /*
        * Increase system responsiveness
      */
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

      /*
        * Hardening
      */
      # Restrict ptrace() usage to processes with a pre-defined relationship
      # (e.g., parent/child)
      "kernel.yama.ptrace_scope" = 1;

      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = 2;

      # Disable bpf() JIT (to eliminate spray attacks)
      "net.core.bpf_jit_enable" = false;

      # Disable ftrace debugging
      "kernel.ftrace_enabled" = false;

      # Enable strict reverse path filtering (that is, do not attempt to route
      # packets that "obviously" do not belong to the iface's network; dropped
      # packets are logged as martians).
      "net.ipv4.conf.all.log_martians" = true;
      "net.ipv4.conf.all.rp_filter" = "1";
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = "1";

      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;

      /*
        * TCP hardening
      */
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      # Do not accept IP source route packets (we're not a router)
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      # Ignore outgoing ICMP redirects (this is ipv4 only)
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      # Ignore incoming ICMP redirects (note: default is needed to ensure that the
      # setting is applied to interfaces added after the sysctls are set)

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

      # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
      # pinging them, unlike my servers.
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv6.icmp_echo_ignore_broadcasts" = 1;

      # May improve system performance
      "sched_autogroup_enabled" = 0;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        configurationLimit = 10;
        enable = true;
      };
    };
  };

  # CPU
  hardware.cpu.amd.updateMicrocode = true;

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=3G" "mode=755" "noatime" "nodev" "nosuid" "noexec" ];
    };

    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      # Note: insufficient size may cause nixos-rebuild to fail (nixos builds on /tmp)
      options = [ "defaults" "size=8G" "mode=755" "noatime" "nodev" "nosuid" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
      ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@persist"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
      ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
        "noexec"
      ];
      neededForBoot = true;
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/55e7ba18-7d5d-41b5-9c11-3de4cfda1b7a";
      fsType = "btrfs";
      options = [
        "subvol=@snapshots"
        "ssd"
        "compress=zstd"
        "space_cache=v2"
        "discard=async"
        "autodefrag"
        "noatime"
        "nodev"
        "nosuid"
        "noexec"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1A6A-41C8";
      fsType = "vfat";
      options = [ "nodev" "noexec" "nosuid" "nodev" "noatime" "noexec" ];
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
