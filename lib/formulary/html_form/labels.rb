module Formulary::HtmlForm::Labels
  def label_for_field(field_name)
    fields_for_name = document.css("*[name='#{field_name}']")

    if fields_for_name.empty?
      raise "Cannot find label, field #{field_name} does not exist"
    end

    if fields_for_name.length > 1
      labels_for_fieldset(fields_for_name)
    else
      label_for_single_field(fields_for_name.first)
    end
  end

protected

  def labels_for_fieldset(fields_for_name)
    labels = fields_for_name.each_with_object({}) do |n, h|
      h[n["value"]] = n.ancestors("label").first.text
    end

    fieldset_legend = fields_for_name.first.ancestors("fieldset").css("legend")
    labels["fieldset"] = fieldset_legend.text
    labels
  end

  def label_for_single_field(field)
    input_id = field["id"]
    label = document.css("label[for='#{input_id}']")

    if label.empty?
      parent_label = field.ancestors("label").first
      if parent_label.nil?
        nil
      else
        parent_label.text.strip
      end
    else
      label.text
    end
  end
end
