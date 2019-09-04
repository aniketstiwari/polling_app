module PollsHelper
  def datepicker_input form, field
    form.text_field field, class: 'datepicker form-control', placeholder: 'YYYY-MM-DD', autocomplete: "off", :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true'}
  end
end
