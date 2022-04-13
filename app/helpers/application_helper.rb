module ApplicationHelper
  def current_persona?(persona)
    # setup default persona
    cookies[:persona] ||= current_user.entity.entity_type == "Startup" ? "startup" : nil
    cookies[:persona] ||= current_user.entity.entity_type == "VC" ? "investor" : nil
    # Check if the persona matches
    cookies[:persona] == persona.to_s
  end
end
