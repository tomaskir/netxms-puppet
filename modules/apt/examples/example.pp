node 'foo.bar.local' {
  # add netxms apt repo
  class { 'apt::netxms_repo':
  }
}
