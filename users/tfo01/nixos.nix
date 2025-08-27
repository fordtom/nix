{
  inputs,
  pkgs,
  ...
}: {
  users.users.tfo01 = {
    home = "/home/tfo01";
    shell = pkgs.bash;
  };

  system.primaryUser = "tfo01";
}
