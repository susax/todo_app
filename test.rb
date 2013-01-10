# conding: utf-8

require 'sinatra'
require 'erb'
require 'active_record'
require 'logger'

set :views, File.dirname(__FILE__)+'/views'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql2',
  :host => 'localhost',
  :username => 'root',
  :password => '',
  :database => 'todo'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

class Todo < ActiveRecord::Base
end

class User < ActiveRecord::Base
end

get '/' do
  @todo = Todo.find(:all, :conditions => { :status => 1}, :order => "term")
  @todo_done = Todo.find(:all, :conditions => { :status => 2}, :order => "term")
  erb :index
end

post '/create' do
  todo = Todo.new(
    :task_name => params[:task_name],
    :registration_date => params[:registration_date],
    :term => params[:term],
    :importance => params[:importance],
    :comment => params[:comment],
  )
  todo.save
  redirect '/'
end

get '/:todo_id/edit' do
  @todo = Todo.find(params[:todo_id])
  erb :edit
end

post '/:todo_id/update' do
  Todo.update(params[:todo_id],
    :task_name => params[:task_name],
    :registration_date => params[:registration_date],
    :term => params[:term],
    :importance => params[:importance],
    :comment => params[:comment],
  )
  redirect '/'
end

get '/:todo_id/done' do |n|
  Todo.update(params[:todo_id], :status => 2)
  redirect '/'
end

get '/:todo_id/undone' do |n|
  Todo.update(params[:todo_id], :status => 1)
  redirect '/'
end

get '/:todo_id/destroy' do
  @todo = Todo.find(params[:todo_id])
  @todo.destroy
  redirect '/'
end

