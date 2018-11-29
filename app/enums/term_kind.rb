class TermKind < ClassyEnum::Base
  def require_signing?
    false
  end
end

class TermKind::Mandatory < TermKind
  def require_signing?
    true
  end
end

class TermKind::Optional < TermKind
end
