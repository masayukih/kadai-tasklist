class TasksController < ApplicationController
	before_action :require_user_logged_in, only: [:show, :edit, :new]
	before_action :set_task, only: [:show, :edit, :update, :destroy]
	
	include SessionsHelper
	
	def index
		if logged_in?
			@user = current_user
			@tasks = current_user.tasks.order("id DESC").page(params[:page]).per(10)
		end
	end
	
	def show
	end
	
	def new
		@task = current_user.tasks.build
	end
	
	def create
		@task = current_user.tasks.build(task_params)
		
		if @task.save
			flash[:success] =  "taskは正常に投稿されました"
			redirect_to @task
		else
			flash.now[:danger] =  "taskが投稿されませんでした"
			render :new
		end
	end
	
	def edit
	end
	
	def update
		if @task.update(task_params)
			flash[:success] = "taskは正常に更新されました"
			redirect_to @task
		else
			flash.now[:danger] = "taskが更新されませんでした"
			render :edit
		end
	end
	
	def destroy
		@task.destroy
		flash[:success] = "taskは正常に削除されました"
		redirect_to tasks_url
	end
	
	private
	
	def require_user_logged_in
		unless logged_in?
			redirect_to login_url
		end
	end
	
	def set_task
		@task = current_user.tasks.find(params[:id])
	end
	
	def task_params
		params.require(:task).permit(:status, :content)
	end
end
