jenkins-notifier-hackfest
=========================

This is the jenkins-notifier app, made for Intersect's Hackfest June 2013.

What does the jenkins-notifier do?
Run as a status-bar application in background when developing. The notifier will inform you if a new build is broken (or a broken build has been fixed), along with the details of the last commit.
If you are running MAC OSX 10.6 or later, the notifier will present you with a status notification message for each event, and will also announce the event through the OSX speech utility.

Rewrite the condfiguration.yml file with your own jenkins details. You can optionally include a username and password for server verification.
The project list is optional. If it is ommitted, the project will provide information on all projects found on the designated jenkins server.
The 'talk' option in the .yml file is used to turn voice notifications on/off.

This project is an adaptation of archiloque's 'jenkins-notifier'

LICENSE:
Copyright (c) 2012 Julien Kirch, released under MIT license

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
