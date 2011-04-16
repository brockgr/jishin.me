# The release management jobs. This is normally a Rakefile
# but because rails hijaks rake (and won't let it run if
# it has any issues, such as outdated modules), this has
# to be done by make. -- Gavin

default:
	@echo "make: No default action"

pre_receive:
	@echo "make: Nothing to do"


post_receive:
	@echo "make: Running bundle install"
	bundle install --local
	@echo "make: Running rake db:migrate"
	rake db:migrate
	@touch "tmp/restart.txt"

restart:
	@echo "make: Ackbar restart - touching tmp/restart.txt"
	@touch "tmp/restart.txt"
