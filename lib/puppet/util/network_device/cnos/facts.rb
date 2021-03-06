# Copyright (c) 2017, Lenovo. All rights reserved.
#
# This program and the accompanying materials are licensed and made available
# under the terms and conditions of the 3-clause BSD License that accompanies
# this distribution. The full text of the license may be found at
#
# https://opensource.org/licenses/BSD-3-Clause
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS, WITHOUT
# WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

# This is a utilty class to fetch facts from the device
class Puppet::Util::NetworkDevice::Cnos::Facts
  attr_reader :transport

  def initialize(transport)
    Puppet.debug(self.class.to_s.split('::').last + ': Inside Initialize of Facts!')
    @transport = transport
  end

  def retrieve
    Puppet.debug(self.class.to_s.split('::').last + ': Retrieving Facts from facts.rb!')
    facts = {}
    facts.merge(parse_device_facts)
  end

  def parse_device_facts
    facts = {
      operatingsystem: :cnos,
    }
    if (response = @transport.call('/nos/api/sysinfo/inventory'))
      Puppet.debug("response  = #{response}")
      result = response
    else
      Puppet.warning('Did not receive device details. CNOS REST requires Administrator level access.')
      return facts
    end

    [:Name,
     :Description,
     :Model,
     :'Manufacture Date',
     :'Serial Number',
     :'Part Number',
     :'Software Revision',
     :'Electronic Serial Number',
     :'Mgmt mac',
     :'Machine Type Model',
     :UpTime].each do |fact|
      facts[fact] = result[fact.to_s]
    end

    facts.each do |key, value|
      Puppet.notice("Key  = #{key} , Value = #{value}")
    end

    facts
  end
end
