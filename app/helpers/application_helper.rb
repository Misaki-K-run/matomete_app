module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-lime-300"
    when :alert  then "bg-red-300"
    when :error  then "bg-yellow-300"
    else "bg-gray-500"
    end
  end
end
