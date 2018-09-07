module ApplicationHelper
    def controller?(controller)
        controller.include?(params[:controller])
    end
    def action?(action)
         action.include?(params[:controller])
    end
end
