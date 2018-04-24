# CNOS ARP example

class cnos::arp {
  cnos_arp{'Ethernet1/1':
    ensure      => 'present',
    if_name     => 'Ethernet1/1',
    ageout_time => 80,
  }
}
