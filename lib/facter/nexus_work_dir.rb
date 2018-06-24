Facter.add(:nexus_work_dir) do
  confine :kernel => :linux
  setcode do
    Facter::Util::Resolution.exec('find / -type d -iname \'sonatype-work\'')
  end
end
