p "TEST"
Merb.logger.info("Loaded TEST Environment...")
Merb::Config.use { |c|
  c[:testing]           = true
  c[:exception_details] = false
  c[:log_auto_flush ]   = true
  # log less in testing environment
  c[:log_level]         = :error

  #c[:log_file]  = Merb.root / "log" / "test.log"
  # or redirect logger using IO handle
  c[:log_stream] = STDOUT
  c[:hostname] = "localhost:4000"
}
Merb::Mailer.delivery_method = :test_send
