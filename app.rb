require 'sinatra'
require "sequel"
require "mysql"



Tilt.register Tilt::ERBTemplate, 'html.erb'

get '/' do
  erb :add
end

get '/createtable' do
	db = Sequel.connect('mysql://root:root@localhost/test')

		db.create_table :users do
	  	primary_key :id
	  	String :name
	end

	db.create_table :messages do
		String :cnt 
		primary_key :id
		foreign_key(:user_id, :users)
		DateTime :time
	end

end

enable :sessions

post '/createuser' do
	db = Sequel.connect('mysql://root:root@localhost/test')
	a = params['t1']
	hash = db[:users][:name => a]

	puts hash


if hash == nil 
	user = db[:users]
	op = user.insert(:name => a)
	puts op
	session['un'] = a
	session['id'] = op

else
	session['un'] = hash[:name]
	session['id'] = hash[:id]
end

	redirect "/messagesroute"
#	erb :messages

end

post '/createmessage' do
	
	db = Sequel.connect('mysql://root:root@localhost/test')
 	new_msg = params['m1']
	message = db[:messages]
	op = message.insert(:cnt => new_msg,:user_id => session['id'], :time => DateTime.now)
	puts op
	redirect "/messagesroute"

end



get '/messagesroute' do
	puts session
	db = Sequel.connect('mysql://root:root@localhost/test')
	msg = db[:messages].all	
	@msgs = msg
	erb :messages
end

get '/checknewmessage' do
	last_msg_id = params['msgid']
	db = Sequel.connect('mysql://root:root@localhost/test')
	new_msgs = db[:messages].where('id > ?', last_msg_id).all
	puts new_msgs
	@new_msg = new_msgs
	erb :newmsg
	#@msgs = new_msg
	
end








