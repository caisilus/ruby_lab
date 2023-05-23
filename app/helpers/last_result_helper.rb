module LastResultHelper
  include ActionView::RecordIdentifier

  def last_result_dom_id(task, user)
    [dom_id(user), dom_id(task, :last_result)].join("_")
  end
end
