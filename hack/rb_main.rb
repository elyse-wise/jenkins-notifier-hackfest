#
#  rb_main.rb
#  MacRubyTest
#
#  Created by Chris Kenward on 13/06/13.
#  Copyright (c) 2013 Chris Kenward. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
#framework 'Cocoa'

framework 'AppKit'
framework 'foundation'


require 'yaml'
require NSBundle.mainBundle.pathForResource("log", ofType:"rb")
require NSBundle.mainBundle.pathForResource("jenkins_notifier", ofType:"rb")
DEFAULT_CONFIGURATION_FILE = NSBundle.mainBundle.pathForResource("configuration", ofType:"yml")




# Loading all the Ruby project files.
#main = File.basename(__FILE__, File.extname(__FILE__))
#dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
#Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
#  if path != main
#    require(path)
#  end
#end
#
# Starting the Cocoa main loop.
#NSApplicationMain(0, nil)

#
# Initialize the stuff
#
# We build the status bar item menu
def setupMenu
    menu = NSMenu.new
    menu.initWithTitle 'Hack'
    # mi = NSMenuItem.new
    #mi.title = 'Hellow from MacRuby!'
    #mi.action = 'sayHello:'
    #  mi.target = self
    #menu.addItem mi
    
    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'quit:'
    mi.target = self
    menu.addItem mi
    
    menu
end

# Init the status bar
def initStatusBar(menu)
    status_bar = NSStatusBar.systemStatusBar
    status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
    status_item.setMenu menu
    absolute_path = NSBundle.mainBundle.pathForResource("star", ofType:"png")
    img = NSImage.new.initWithContentsOfFile absolute_path
    status_item.setImage(img)
end

#
# Menu Item Actions
#
def sayHello(sender)
    alert = NSAlert.new
    alert.messageText = 'This is MacRuby Status Bar Application'
    alert.informativeText = 'Cool, huh?'
    alert.alertStyle = NSInformationalAlertStyle
    alert.addButtonWithTitle("Yeah!")
    response = alert.runModal
end
def quit(sender)
    app = NSApplication.sharedApplication
    app.terminate(self)
end

# Rock'n Roll
app = NSApplication.sharedApplication
# Create the status bar item, add the menu and set the image
initStatusBar(setupMenu)
#try doing stuff


JenkinsNotifier::Log.create(false)

configuration_relative_path = DEFAULT_CONFIGURATION_FILE

configuration_path = File.expand_path(configuration_relative_path, File.dirname(__FILE__))

JenkinsNotifier::Log.info "Use configuration file [#{configuration_path}]"

unless File.exist? configuration_path
    abort "Configuration file [#{configuration_path}] not found"
end


notifier = JenkinsNotifier::JenkinsNotifier.new
queue = Dispatch::Queue.new('hack')
queue.async { notifier.start }


puts "created"
#thread = NSThread.alloc.initWithTarget( notifier, selector:'start', object:nil)
#thread.start

app.run
