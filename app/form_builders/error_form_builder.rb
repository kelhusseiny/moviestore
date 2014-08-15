class ErrorFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, to: :@template

  %w[text_field text_area email_field password_field collection_select date_field number_field file_field].each do |method_name|
    define_method(method_name) do |name, *args|
      super(name, *args) + render_errors(object, name)
    end
  end

  private
  def render_errors(object,name)
    if object.errors[name].present?
      content_tag :div, style: "color:#FF6B52;" do
         name.to_s.capitalize + " " + object.errors[name].join(" & ")
      end
    end
  end
end
