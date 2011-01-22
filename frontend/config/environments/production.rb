Merb.logger.info("Loaded PRODUCTION Environment...")
Merb::Config.use { |c|
  c[:exception_details] = false
  c[:reload_classes] = false
  c[:log_level] = :error
  
  c[:log_file]  = Merb.root / "log" / "production.log"
  c[:hostname] = "s2.rootnode.net"
  # or redirect logger using IO handle
  # c[:log_stream] = STDOUT
}
