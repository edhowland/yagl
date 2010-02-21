YAGL - Yet another Generator Language

This is a DSL meant to create a Rails/RSpec-like generator script. The resulting script will copy files from a template folder to a destination folder, making changes along the way. So instead rolling your own generator script, use yagl to get started.

Installation:
 sudo gem install yagl

Synopsis

 yagl [options] [script.ygl] [script]

script.ygl:
 # commentary
 variable_1=value
 variable_2=value
 force=true
 
 option :local
 option :remote do |o|
   o.mutex_with [:local]
   o.short=:m
   o.desc="List remote gems"
   o.arg=[:optional, /url_regex/]
 end
 
 command :help
 command :install do |ctx|
   ctx = %Q{code if force?}
 end
 
 template :root, "path/to/template"
 template :ruby, "ruby"
 template :java, "java"
 template :ruby_19, "ruby-1.9" do |ctx|
   # code to be run when processing 
 
 usage :default, "How to run me"
 usage :help, "Help about help"
 usage :install do |pre, opts, post|
    pre="Help for the install command"
    opts="override option list with your own"
    post="Thanks for running the install command!"
 end
 usage :post_run, "A string to printed after the processing loop completes"
 
 event_hooks do |ev|
   ev.on_copy do |pre, handler, post|
     handler = lambda {...}
   end
   ev.on_overwrite {|pre, h, post| ...}
  end
 
 run!  # execute it


About

I wrote Yagl because I was tired of always re-writing common command line parsing scripts. Also, I saw a need to write generator scripts like rails or rspec-on-rails for various gems I was writing. This is a very straightforward aet of steps, so why constantly rewrite it everytime. Generally you process some command line arguments, set internal variables, run the loop to recurse the templates folder and copy/overwrite the files in the destination.

Usage

embedded:
 require "rubygems" # if needed
 require "yagl"
 
 ... 
 script = Yagl::Parser.parse(<<-EOC
 
 [yagl dsl code]
 
 EOC
 )
 
 script.write(path)
 # -- or --
 File.open(path, 'w+') do |f|
  f.write(script.to_s)
 end
--- 
 
Command line:
  yagl [options] [script.ygl  [script]]
  
The script.ygl contains code written in the Yagl DSL. Once parsed, it runs it and generates the resulting script. Running the script:

 ./output [option] dest
 
will copy files from a template, to the dest folder. If any matching pathnames already exist, the user will be promted to overwrite them (or diff them, etc.), unless the -f, --force options are given.

Note both file names are optional. Running yagl with only a dir will generated a completely functional generator script, after trying to sus out the templates and bin folder.

For instance, say you are in your spec_wire gem source folder and want to create a bin/spec_wire command that read from the templates folder.

yagl .

would create bin/spec_wire with a full set of options.

Erb or Haml templates

Template files can have the extension .erb or .haml and will be run through ERb or Haml before being written to the destination path. This alows substitution of generator variables prior to being written out. The extensions (.erb, .haml) are removed prior to being copied. Using .i after the extension will ignore this process and leave the extension as is. This is useful for Rails/Sinatra views and other frameworks. This can also be indicated via the DSL.



YAGL DSL.

The YAGL DSL looks a lot like Ruby. It is inspired by Rake and Capistrano syntax. Notably, an empty .ygl file will actually generate a usable generator script. Using the convention over configuration mantra, the yagl script scans for a template or templates folder and builds in several standard options. Therefore all you need to do is setup a templates folder with your files and off you go. Doing only this will not be very useful if you need to set configuation options, etc. via the .erb or .haml templates. That is where Yagl really helps you out.

Variables

Variables in Yagl are normal Ruby variables, you can use built-in types, define your own classes, whatever.

version = "1.5.8"
myvar2 = MyClass.new(value_from_cmd_line)

Then, in some file, like config/environment.rb.erb, these lines would be replaced:

config.version="<%= version %>"
config.other_setting=<%= myvar2 $>  # calls myvar.to_s

Finally, writing out config/environment.rb

... [more about variable]

Options

Options are options you would like for your generator script. Examples of options are -d, --database, -g, --git, etc. [See rails --help or ./script/generate rspec --help in a Rails folder.]

option :path        # Defaults to [-g, --git]
option :git, :svn   # [-g, --git, -s --svn]
option :custon do |o|
  o.short = :C
  o.long = 'custom-option'
end                         # [-C, --custom-option]

Options use the StdLib GetOptLong. So you can write custom stuff in the block given to option. E.g.

option :server_url do |o|     # --server-url Note: _ changed to -
  o.short = 'u'               # swtich -s to -u 
  o.arg = [:required, /.../]  # required, regex to match 
  o.var = :url                # creates or uses url variable
end

By default, inside your script, any option that takes an argument, will place the supplied argument into a matching variable named for the symbol. The variable of previously defined with a normal Ruby syntax "var=value", will use that object's '=' method, passing it a string (the supplied arg). For example:

class ServerUrl
  attr_reader :value
  def initialize(default)
    @value=default
  end
  def =(value)
    @value = value
  end
  def to_s
    @value
  end
end

my_arg = ServerUrl.new('http://localhost:3000')

option :server_url {|o| o.arg=true; o.var=:server_url} 

Within your .erb file, '<%= server_url %>' will be replaced with any argument supplied on the command line, or default if any. Of course, you could bypass this and just use the shortcut with no predefined variable:

option :server_url do |o|
  o.short=:u
  o.arg=true
  o.default='http://localhost:3000'
  o.desc='The url where the server runs.'
end

which accomplishes the same thing. The custom option class pattern is widely used, that we've created a base class for you. The BaseOption class has many of the things you'd need as a starting point to write your own options. E.g.

class MyOption < Yagl::BaseOption
  def initialize(default)
    super default
    @short = :u
    @long = :universal
    @arg = [/.../]         # no :required, the argument is optional
  end
  def to_s
    # customize the string here
  end
end

option MyOption.new('http://localhost:4567')

In fact, an instance of Yagl::BaseOption is what is passed to the block in the option method. To make life even easier, there are derived classes that setup options on these options. Hopefully, these are selfExplanatory

option Yagl::Option::Required.new(:do_it) # option required, takes no args

Yagl::Option::ArgumentRequired
Yagl::Option::ArgumentOptional

These translate into the GetOptLong constants.

Any of these can be further customized in the block, if passed:

option Yagl::Option::Required.new(:do_it) do |o|
  o.short=:i
end

Or, as I've said, write your own class. Any method you've defined or any accessor method can be callled within the block.

There are several options built-in that you don't have to specify. Any of these can be removed via the no_option command (takes a list of symbols). E.g.:

no_option :help, :pretend, :quiet

You can put this ahead of any options and then redefine their behavior:

no_option :help
option :help do |o|
  ...
end

Another way to accomplish the same thing is to manipulate the options array:

options -= [:help, :dry_run, :template]

[See Predefined options]

Options without arguments are taken to be boolean variables within your generator script. So, the simplest option :julianne_frys would create a variable in your script:

julianne_frys=false

Then, when run and passed --julianne-frys or -j, the variable would be set to true. Within any .erb or .haml template files, <%= julianne_frys %> would be set to the string "true". Or you can write stuff like this in .haml files

%html
  %body
    - if julianne_frys
      .cook
        Juliannes frys, too!


You can set the option to be true by default, thus:

option :julianne_frys, true

or in the block

option :julianne_frys do |o|
  o.default = true
end

There is a lot of interpolation going on here. In addition to auto creation of variables via option symbol to variable name, and option long name and short name, it also does a few other things for you. In the case of the aforementioned boolean options, you get an automatic --no-option. E.g --no-juliane-frys, which of course sets the opposite of your default setting. Additionaly, it will try to infer your description automagically, if none is supplied. E.g. the usage line for the above option would read:

  -j, --[no-]julianne-frys            Julianne frys
  
So making your option names self-explanatory, helps write the usage instructions as well. You can turn off this feature via passing a string
to the #desc attribute of the option or passing false or :blank, which will just list the option but give it a blank string.

Finally, CamelCase conversion to underscores happens with constants, class names: 

JulianneFrys=true
option JulianneFrys

=>
   --[no]julianne-frys       Julianne frys [default: true]
   
   # in script 
   julianne_frys=true

Non-boolean options

For options that are string-like, but don't take an argument (which replaces the default), declare the option as a string, rather than a symbol. E.g.

option "Julianne"

This would declare a variable, named julianne, set to "Julianne" for use within <%= %> or other contexts. You'd change the name of the variable, as usual in the block:

option "Julianne" do |o|
  o.arg=:julianne_frys
end

# in the script:

The option, if not "--no-julianne", would set it 

julianne_frys="Julianne"

or it would be set to nil, otherwise. To set it to '', use o.default=:blank or o.default=''.

Another shorthand for setting options on the options, is to pass it a hash:

option :julianne-frys, :short=>:f, :arg=>[:required]

Using the block form gives you a little more control. For instance, in the usual GetOptLong option processing case statement, you can pass a proc for the when clause. This overrides the default behavior in the when. Taking the simple case:

option :julianne_frys

would result in the following in your script:

julianne_frys=false
def julianne_frys?
  julianne_frys
end
def julianne_frys!
  julianne_frys=true
end

...
case opt
  ..
  when '--julianne-frys'
    julianne_frys!
  when ...
  
end

In your .erb templates:
  <% if julianne_frys? %>
     ... something 
  <% else %>
     ... something else
  <% end %>
  
But, lets say you wanted to do more than that.

option :juliann_frys do |o|
  o.when_clause do |c|
    # compute some stuff
    c=<<-EOC
      Some ruby code to be placed with #{substitutions}
      ...
    EOC
  end
end

The proc here is late bound. I.e. is it is a usual closure, capturing any variables up to this point, but it's execution is deferred unttil the case statement is written out. This makes it trivial to set values in the case statement that won't be set until, perhaps other options are set. A simple example of two mutually exclusive options would be:

mutex_msg='can't both slice-n-dice and julianne-frys'
option :julianne_frys do |o|
  o.when_clause do |c|
    c="fail(mutex_msg) if slice_n_dice?"
  end
end
  
option :slice_n_dice do |o|
  o.when_clause {|c| c="fail(mutex_msg) if julianne_frys?"}
end 

However, since this is such a frequent use case, mutually exclusive options can be set much easier than that:

option :julianne_frys do |o|
  o.mutex_with [:slice, :dice, :chop]
end

Note: you only have to set a mutex once, it will affect all the other mutexs automatically. However, you could override that behavior with:

option :slice {|o| o.mutex_with -= [:dice]} # can slice and dice, but not with
                                            # chop or julianne-frys

For mutexs, you automatically get failure messages that say the logical thing. This can be overridden with the #mutex_fail_msg attribute of the option.  

Note, any variables you've set would get set ahead of any option processing. So the output of the case statement would use the state of those variables, executing the proc at that time. But variables can be set in any order and depend on other variables. And can happen after options are declared. The current state of those variables when the case statement is written is used when the when_clause proc gets called. You can do some complex processing, both outside of and inside the proc. One example of this might be: some code that infers the whereabouts of certain templates. (See Templates below.) You might have multiple set of templates, determined by options.

[ assume current project has ./errata/templates/ruby, ./errata/php]
# search for a path to the template root in the current project
# this following part is built into Yagl, but shown here for illustration:

Dir['**/templates'] do |t|  # runs when Yagl parses this
  template_root=t           # template_root='./errata/templates
end

option :ruby do |o|
  o.when_clause do |c|      # deferred until script generated 
    templates_path=File.join(template_root, 'ruby')
    c="templates_path='#{templates_path}'"
  end
end

option :php do |o|
 ...
end

# some later code recomputes the actual templates root. This might happen because the first occurance of a templates folder might be for some doocumentation purposes, not for generation purposes. Thus:

template :root => 'src/templates'

would override the above search if there existed a ./doc/templates first in the list. Therefore, calling the block at script generation time would do the correct thing.

So there are many ways of creating options, and many shortcuts for doing so. Hopefully, this makes writing scripts with option processing easier. But, say you want to be even more elaborate. Read on, dear friend.

Commands

Commands are a way of specifying words or phrase arguments that do not start with '--' or '-'. They are like options but may specify different behavior than options. An example is the gem command. 'gem install', 'gem update --system'. The last example shows that commands can be used with options as well.

Commands can be standalone or take arguments. They can take multiple arguments, and 0 or more options. E.g. 'gem install --no-rdoc rails mysql'

For a generator script, commands simply a way of providing more functionality than would be usefull with just options alone. Of course, you can do anything you want with commands, so Yagl lets you write pretty complicated scripts.

command :help     # automagically lists available commands and adds help
                  # processing to them

command :updatte do |ctx|
  # this proc executed when script is written out
  ctx = <<-EOC       # this code executed when command is run
    some.ruby code
  EOC  
end

Commands can take options too:

command :list do |ctx|
  variable=true
  option :local
  option :remote, :mutex_with => [:local]
  option :installed do |o|
    o.desc="Lists installed gems"
  end
  option :removed {|o| puts o.name unless variable?}
  
  # now set your command's context
  ctx << "system('ls -lR') if local? " # use arguments from above 
end

Templates

Template methods set various templating options, such as the template root and so forth. The simplest thing is to set no templates. Doig that, Yagl will attempt to sus out an existing template or templates folder in your current project. To not do anything, i.e. not process templates at all, set it to nil.

tempate nil

Some other examples

template "path/to/templates"  # sets the root template

template :root, "path/to/template_root"
template :ruby, "ruby-1.8"
template :ruby19, "ruby-1.9"

The above would set templates of 

"path/to/template_root/ruby-1.8", "path/to/template_root/ruby-1.9"

Templates usually just set a symbol table. You can look up any template by calling the templates hash. By default, the templates hash will respond with the fully constructed path, given the root. E.g.:

templates[:ruby] # => "path/to/templates/ruby"

However, templates also take a block. This allows for additional work to be done when template processing occurs. This block gets executed once the script gets written out, and the code to be executed during template processing is substituted. The code is executed when there is a matching path being performed. E.g.

template :ruby_1_9, "ruby-1.9" do |path, file, ext|
  # delete require "rubygems" from .rb.erb file
end
template :ruby "ruby"    # .rb.erb files are left alone

Turning off .erb, .haml processing:

To ignore the normal processing of a file ending in .erb, or .haml, which would run the code and strip off the extension, adding a .i to the extension will strip off just the .i. However you can do it with the template method as well.

template :file, "path/to/file" do |file|
  file.ignore_processing
end 


Running yagl

Place this at the end of your .ygl script:

run!

This command causes the script to execute and perform the template processing for you. There is an automatic option added --no-run which overrides this. This is different than the --dry-run which crawls the templates and prints what would have happened.

Leaving out this command results in a script that accepts commands, options and templates, but produces no output. This might be useful if you want to write your own processing loop. [Also see Embedding Yagl below]

run! takes a block that gets yields every directory and file before it is processed:

run! do |path, file|
  puts "working on #{path}/#{file}"
end

file is nil, if this is a directory.

Events

Events are steps that occur in the processing of the script. For any event, there is a default handler supplied by the Yagl runtime. But you can replace/augment these events in your .ygl script. This is entirely optional. Out of the box, Yagl will generate perfectly crafted generator scripts. You may wish to hook into Yagl's default behavior.

event_hooks do |ev|
  ev.on_overwrite do |ante, handler, post|
    ante = lambda {|path, file| puts "overwritng #{path}/#{file}"}
    handle = lambda do |src_path, dest_path, file|
      do 
        print "Do you want to Y,n,a,d? "
        option = gets
        case option
          when 'd'
           system("diff #{src_path}/#{file} #{dest_path}/#{file}")
          when
             ...
        end
      while ...
    end
    post = lambda {|src_path, dest_path, file| ...}
  end
  
  ev.on_mkdir ...
end
  
All events come with a pre-, during and post- handler. Any of these can be overridden or augmented. You augment a handler by adding to the handler array on the event_hooks call:

event_hooks do |ev|
  ev.on_mkdir do |antes, handlers, posts|
    handlers += [lambda {|path| log "#{path} created!"}]
  end
end

Of course, the above could have been written with a post handler. Most of the pre- and post- handlers are empty arrays.

The current handler is passed into your event hook so you could create an around method by just calling it in your context:

event_hooks do |ev|
  ev.on_mkdir do |antes, handler, posts|
    handler = lambda do |path|
      handler.call(path) if File.permission?(path) # TODO research
    end
  end
end
 

Defined events:

Option/command processing events:
on_parsing_options 
on_parsing commands
on_parsing templates

File/path events fired during template processing:
on_copy |src, dest, file|
on_overwrite |src, dest, file|  # fired before on_copy
on_mkdir |path|

Miscellaneous events:
on_usage |command, msg| # when setting usage for a command or the overall
                        # script if command is :default 
on_run        # before, during and after template processing

Usage:

Setting the usage for any command or the default.

usage :command, %Q{
  Usage for command
  --options options for command.
}

usage :default, "$0 --help"
-- or simply
usage "--help"

By default, the help command, if supplied, will print the usage for all commands that have usage statements supplied. Any options for a command will be printed as well at the end. This can be overridden by passing a block to the usage method:

usage :install do |preamble, options, postamble| 
  preamble = "Installs a gem"
  postable = %Q{
    Thank you for using Rubygems!
    Donate by buying us a beer next time we are in your town.
  }
end


Verbose hooks

Normally, the default --verbose flag, if set will not do anything except set the verbose? flag to true. You could use this in your run! block for instance:

run! do |ctx|
  puts ctx.to_s if verbose?
end

However, you can do more with it via setting verbose hooks. Hooks are available for various events, like potentially overwrting a file:

verbose_hook do |v|
  v.on_overwrite do |ev|
    puts "it is very dangerous to overwrite #{ev.path}!"
  end
end

This would only happen if the -v option occurred and the system detected amatching source file that it was going to overwrite. The -q, --quite option would override this behavior.

Exceptions

Exception hooks for various kinds of exceptions

exception :NoSuchFile do |ctx|
  # once again this is executed at script generation time
  ctx = %Q{...} This code block substitutes normal handler for this exception
end



You can set verbose hooks for any event Yagl understands. [See Events]

Ruff! Ruff!

Yagl eats its own dogg food, too. Yagl scripts are generated from a template. You can write your own template, and specify that to yagl with the --template option. In fact, the Yagl command line tool itself is really just a Yagl DSL script that you can customize. 

Embedding Yagl

You can embed yagl two ways. You can have yagl just generate the option and command processing into a stand-alone script that you require. You'd then have all the variables and helper predicates available at your disposal without it doing any processing. You accomplish this with the --no-run command to yagl. Note, you can call yagl's run! command at anytime later. And still pass it a block. Note. The original block, if any, passed to the run! methood in the script will be called first, then any block you pass later will be called.

You can also embed the Yagl parser in your code. You can use this, for instance, to create only option parsing in an easier fashion than rolling it your self.




Predefined options

-h, --help          Print out the usage message (See usage)
-d, --[no-]dry-run   Execute but don't actually do anything, print out result             
-p, --[no-]pretend  Alias for dry-run
-v. --version       Print out the version of this script or gem's VERSION file
-V. --verbose       Sets the verbose flag. See Verbose hooks for more info.
-q, --quiet         The opposite of verbose, nothing is printed.
-t, --template      Sets the template root for the script.
-f, --[no-]force    overwrites force
   
 
 

