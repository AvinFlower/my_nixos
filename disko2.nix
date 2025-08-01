{
  disko.devices.disk.main = {
    device = "/dev/vda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          index = 1;
          size  = "512M";
          type  = "EF00";
          content = {
            type         = "filesystem";
            format       = "vfat";
            mountpoint   = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          index = 2;
          end   = "-2G";
          content = {
            type       = "filesystem";
            format     = "ext4";
            mountpoint = "/";
          };
        };
        encryptedSwap = {
          index = 3;
          size  = "10M";
          content = {
            type             = "swap";
            randomEncryption = true;
            priority         = 100;
          };
        };
        plainSwap = {
          index = 4;
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
