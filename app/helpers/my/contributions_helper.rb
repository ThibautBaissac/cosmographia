
module My::ContributionsHelper
  def contribution_level(count)
    case count
    when 0
      'level-0'
    when 1..2
      'level-1'
    when 3..4
      'level-2'
    when 5..6
      'level-3'
    else
      'level-4'
    end
  end
end
