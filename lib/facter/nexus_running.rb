Facter.add(:nexus_running) do
  confine :kernel => :linux
  setcode do
    nexus_status = Facter::Util::Resolution.exec('systemctl --type=service --state=running | grep nexus.service')
    if nexus_status.empty?
      false
    else
      true
    end
  end
end
