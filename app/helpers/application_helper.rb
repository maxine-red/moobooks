module ApplicationHelper
  # https://gist.github.com/mynameispj/5692162
  def current_path?(test_path)
    return 'active' if request.path == test_path
    ''
  end
end
