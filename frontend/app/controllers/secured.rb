class Secured < Application
  before(:ensure_authenticated)
end
