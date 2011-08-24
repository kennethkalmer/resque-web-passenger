resque-web-passenger
====================

This project exists solely to support running resque-web in a virtual
host, and separate from the virtual host running your main application.

Usage
-----

You can update the locations in `resque-web.yml` to point to the
configuration files used in your real application, so no need to
duplicate them here.

Tweaking required
-----------------

This is very opinionated and serves as an example, although I deploying
this to our infratructure from this branch with Chef...

This should be a great starting point for you.

Shortcomings
------------

You'll manually need to restart this application if your redis details
changed in any way, or configure passenger to run this application for
very short periods of time.
