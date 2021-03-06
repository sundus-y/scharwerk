# current user task
class TasksController < ApplicationController
  before_filter :authenticate_user!

  def show
    task_missing && return
    respond_with current_user.active_task
  end

  # assign free task to user
  def create
    if current_user.active_task
      render text: 'already assiged', status: :bad_request
      return
    end

    stage = params['stage']
    task = Task.where(stage: Task.stages[stage]).free.first
    task.assign(current_user)
    respond_with task
  end

  # mark task as completed
  def update
    task_missing && return
    if params['done']
      task = current_user.active_task
      task.finish
      GitWorker.perform_async(task.id)
    end

    render json: { status: 'done' }, status: :ok
  end

  # free task from user
  def destroy
    task_missing && return
    current_user.active_task.release
    render json: { status: 'released' }, status: :ok
  end

  private

  def task_missing
    current_user.active_task && return

    render json: { text: 'not found' }, status: :not_found
    true
  end
end
