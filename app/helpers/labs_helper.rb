module LabsHelper
  def task_template(template, task)
    percentage = task.last_result&.passed_percentage&.round(2)
    percentage = 0 if percentage.nil?
    render partial: template, locals: { task: task }
  end
end
