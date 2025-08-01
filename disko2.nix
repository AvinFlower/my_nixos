{
  disko.devices.disk.main = {
    device = "/dev/vda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        "01-ESP" = {
          size  = "512M";
          type  = "EF00";
          content = {
            type         = "filesystem";
            format       = "vfat";
            mountpoint   = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        "02-root" = {
          end   = "-2G";
          content = {
            type       = "filesystem";
            format     = "ext4";
            mountpoint = "/";
          };
        };
        "03-encryptedSwap" = {
          size  = "10M";
          content = {
            type             = "swap";
            randomEncryption = true;
            priority         = 100;
          };
        };
        "04-plainSwap" = {
          size  = "100%";
          content = {
            type           = "swap";
            discardPolicy  = "both";
            resumeDevice   = true;
          };
        };
      };
    };
  };
}
