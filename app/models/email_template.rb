class EmailTemplate < Message

  def copy_attributes
    attributes.reject { |k,v| %w[title state email_template_id].include?(k) }
  end
  
end
