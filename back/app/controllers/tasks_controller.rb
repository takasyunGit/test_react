class TasksController < ApplicationController
  def index
    task_all = Task.all
    render json: task_all
  end

  def create
    Task.create(name: params[:name], is_done: params[:is_done])
    render :json, status: :ok
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    head :ok
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    head :ok
  end

  private

 def task_params
   params.require(:task).permit(:name, :is_done)
 end
end
